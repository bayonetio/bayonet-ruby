require_relative './api_helper.rb'

module BayonetClient

  class Lending

    BASE_PATH = "/lending"

    def self.report_transaction(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/transaction/report", params)
    end

    def self.report_transaction_and_consult(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/transaction/report?consult=true", params)
    end

    def self.consult(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/consult", params)
    end

    def self.feedback(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/feedback", params)
    end

    def self.feedback_historical(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/feedback-historical", params)
    end
  end

end