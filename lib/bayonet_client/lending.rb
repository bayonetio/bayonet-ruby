require_relative './api_helper.rb'

module BayonetClient

  class Lending
    def self.report_transaction(params)
      BayonetClient::ApiHelper.request('/lending/transaction/report', params)
    end

    def self.report_transaction_and_consult(params)
      BayonetClient::ApiHelper.request('/lending/transaction/report?consult=true', params)
    end

    def self.consult(params)
      BayonetClient::ApiHelper.request('/lending/consult', params)
    end

    def self.feedback(params)
      BayonetClient::ApiHelper.request('/lending/feedback', params)
    end

    def self.feedback_historical(params)
      BayonetClient::ApiHelper.request('/lending/feedback-historical', params)
    end
  end

end