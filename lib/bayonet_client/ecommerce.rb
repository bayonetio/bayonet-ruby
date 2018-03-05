require_relative './api_helper.rb'

module BayonetClient

  class Ecommerce

    BASE_PATH = "/sigma"

    def self.consult(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/consult", params)
    end

    def self.feedback_historical(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/feedback-historical", params)
    end

    def self.update_transaction(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/update-transaction", params)
    end

    def self.whitelist(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/labels/whitelist/add", params)
    end

    def self.remove_from_whitelist(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/labels/whitelist/remove", params)
    end

    def self.block(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/labels/block/add", params)
    end

    def self.remove_from_block(params)
      BayonetClient::ApiHelper.request("#{BASE_PATH}/labels/block/remove", params)
    end
  end

end