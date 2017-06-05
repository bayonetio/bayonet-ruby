require 'json'

module BayonetClient

  class BayonetResponse
    attr_accessor :feedback_api_trans_code, :rules_triggered,
                  :risk_level, :payload, :reason_code,
                  :reason_message, :request_body, :bayonet_fingerprint,
                  :raw

    def initialize(parsed_response)

      if parsed_response.key?('feedback_api_trans_code')
        self.feedback_api_trans_code = parsed_response['feedback_api_trans_code']
      end
      if parsed_response.key?('rules_triggered')
        self.rules_triggered = parsed_response['rules_triggered']
      end
      if parsed_response.key?('risk_level')
        self.risk_level = parsed_response['risk_level']
      end
      if parsed_response.key?('payload')
        self.payload = parsed_response['payload']
      end
      if parsed_response.key?('reason_code')
        self.reason_code = parsed_response['reason_code']
      end
      if parsed_response.key?('reason_message')
        self.reason_message = parsed_response['reason_message']
      end
      if parsed_response.key?('request_body')
        self.request_body = parsed_response['request_body']
      end
      if parsed_response.key?('bayonet_fingerprint')
        self.bayonet_fingerprint = parsed_response['bayonet_fingerprint']
      end
      self.raw = parsed_response
    end
  end
end
