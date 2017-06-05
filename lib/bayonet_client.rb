require 'httparty'
require_relative './bayonet_client/version'
require_relative './bayonet_client/response.rb'
require_relative './bayonet_client/exceptions.rb'

module BayonetClient

  class Client

    def initialize(api_key, version)

      if version.nil? || version.empty?
        message = 'Please specify Api version'
        raise BayonetClient::InvalidClientSetupError.new message
      elsif !BayonetClient::SUPPORTED_API_VERSIONS.include?(version)
        message = 'This library does not support version specified. Consider updating your dependencies'
        raise BayonetClient::InvalidClientSetupError.new message
      end

      @api_key = api_key
      @version = version
    end

    def consulting(params)
      if validate_params(params)
        serialized = json_from_params(params)
        request('/consulting', serialized)
      else
        raise BayonetClient::BayonetError.new(params, '', '', 'Invalid params. Please make sure you pass a params hash')
      end
    end

    def feedback(params)
      serialized = json_from_params(params)
      request('/feedback', serialized)
    end

    def feedback_historical(params)
      serialized = json_from_params(params)
      request('/feedback-historical', serialized)
    end

    def get_fingerprint_data(params)
      serialized = json_from_params(params)
      request('/get-fingerprint-data', serialized)
    end

    def validate_params(params)
      params.class == Hash
    end

    def json_from_params(params)
      # Add api_key to params
      params[:api_key] = @api_key
      params.to_json
    end

    def request(route, json_params)
      request_json_string(route, json_params)
    end

    def request_json_string(route, request_json_args)
      fq_hostname = fully_qualified_api_host_name(route)
      url = "#{fq_hostname}#{route}"

      headers = {'User-Agent' => 'OfficialBayonetRubySDK',
                 'Content-Type' => 'application/json', 'Accept' => 'application/json'}

      raw_resp = HTTParty.post(
          url, body: request_json_args, headers: headers, verify: false)

      if raw_resp.code == 200
        BayonetClient::BayonetResponse.new(raw_resp)
      else
        raise BayonetClient::BayonetError.new(request_json_args, headers, raw_resp.code, raw_resp)
      end
    end

    def fully_qualified_api_host_name(route)
      default_domain = 'api.bayonet.io'
      if route == '/get-fingerprint-data'
        default_domain = 'fingerprinting.bayonet.io'
      end
      api_version_namespace = 'v' + @version
      "https://#{default_domain}/#{api_version_namespace}"
    end
  end

end
