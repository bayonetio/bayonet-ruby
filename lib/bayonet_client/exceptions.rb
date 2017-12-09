require 'json'

module BayonetClient

  class BayonetError < Exception
    attr_accessor :request_body, :request_headers, :http_response_code, :http_response_json,
                  :reason_code, :reason_message

    def initialize(request_body, request_headers,
                   http_response_code, http_response_json, reason_code = nil, reason_message = nil)
      self.request_body = request_body
      self.request_headers = request_headers
      self.http_response_code = http_response_code
      self.http_response_json = http_response_json
      self.reason_code = reason_code
      self.reason_message = reason_message

      # Get reason_code and reason_message from response
      if http_response_json.class == HTTParty::Response && http_response_json.key?('reason_code')
        self.reason_code = http_response_json['reason_code']
      end
      if http_response_json.class == HTTParty::Response && http_response_json.key?('reason_message')
        self.reason_message = http_response_json['reason_message']
      end
      if http_response_json.class == HTTParty::Response && http_response_json.key?('status')
        self.reason_message = http_response_json['status']
        self.reason_code = -1
      end
    end
  end

end
