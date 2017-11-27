require_relative './api_helper.rb'

module BayonetClient

  class Lending
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