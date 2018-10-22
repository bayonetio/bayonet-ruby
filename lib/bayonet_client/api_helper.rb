require_relative '../bayonet_client.rb'

module BayonetClient
  class ApiHelper
    def self.validate_params(params)
      params.class == Hash
    end

    def self.json_from_params(params, route)
      # Add api_key to params
      if route == '/get-fingerprint-data'
        params[:api_key] = BayonetClient.api_key
      else
        params[:auth] = {}
        params[:auth][:api_key] = BayonetClient.api_key
      end
      params.to_json
    end

    def self.request(route, params)
      unless validate_params(params)
        raise BayonetClient::BayonetError.new(params, '', '', 'Invalid params. Please make sure you pass a params hash')
      end
      json_params = json_from_params(params, route)
      request_json_string(route, json_params)
    end

    def self.request_json_string(route, request_json_args)
      fq_hostname = fully_qualified_api_host_name(route)
      url = "#{fq_hostname}#{route}"

      headers = {'User-Agent' => 'OfficialBayonetRubySDK',
                 'Content-Type' => 'application/json',
                 'Accept' => 'application/json'}

      begin
        raw_resp = HTTParty.post(
            url, body: request_json_args, headers: headers, verify: false, timeout: BayonetClient.timeout)
      rescue Net::ReadTimeout => e
        raise BayonetClient::BayonetError.new(request_json_args, headers, nil, nil, -1, 'Request timed out. If you explicitly set a timeout, consider raising the timeout value')
      end

      if raw_resp.code == 200
        BayonetClient::BayonetResponse.new(raw_resp)
      else
        raise BayonetClient::BayonetError.new(request_json_args, headers, raw_resp.code, raw_resp)
      end
    end

    def self.fully_qualified_api_host_name(route)
      # default_domain = 'api.bayonet.io'
      default_domain = 'localhost:8080'
      api_version_namespace = 'v' + BayonetClient.version
      if route == '/get-fingerprint-data'
        default_domain = 'fingerprinting.bayonet.io'
        if BayonetClient.version == '2'
          api_version_namespace = 'v1'
        end
      end
      # "https://#{default_domain}/#{api_version_namespace}"
      "http://#{default_domain}"
    end
  end
end
