require_relative './api_helper.rb'

module BayonetClient

  class Ecommerce
    def self.consulting(params)
      BayonetClient::ApiHelper.request('/consulting', params)
    end

    def self.feedback(params)
      BayonetClient::ApiHelper.request('/feedback', params)
    end

    def self.feedback_historical(params)
      BayonetClient::ApiHelper.request('/feedback-historical', params)
    end

    def self.update_transaction(params)
      BayonetClient::ApiHelper.request('/update-transaction', params)
    end

    def self.whitelist(params)
      BayonetClient::ApiHelper.request('/labels/whitelist/add', params)
    end

    def self.remove_from_whitelist(params)
      BayonetClient::ApiHelper.request('/labels/whitelist/remove', params)
    end

    def self.block(params)
      BayonetClient::ApiHelper.request('/labels/block/add', params)
    end

    def self.remove_from_block(params)
      BayonetClient::ApiHelper.request('/labels/block/remove', params)
    end
  end

end