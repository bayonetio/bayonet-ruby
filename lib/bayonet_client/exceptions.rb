require 'json'

module BayonetClient

  class BayonetError < Exception
    attr_accessor :request_body, :request_headers, :http_response_code, :http_response_json,
                  :reason_code, :reason_message, :status

    def initialize(request_body, request_headers,
                   http_response_code, http_response_json)
      self.request_body = request_body
      self.request_headers = request_headers
      self.http_response_code = http_response_code
      self.http_response_json = http_response_json

      # Get reason_code and reason_message from response
      if http_response_json.class == HTTParty::Response && http_response_json.key?('reason_code')
        self.reason_code = http_response_json['reason_code']
      end
      if http_response_json.class == HTTParty::Response && http_response_json.key?('reason_message')
        self.reason_message = http_response_json['reason_message']
      else
        self.reason_message = http_response_json
      end
      if http_response_json.class == HTTParty::Response && http_response_json.key?('status')
        self.status = http_response_json['status']
      end
    end
  end

  class InvalidClientSetupError < Exception
  end

end
