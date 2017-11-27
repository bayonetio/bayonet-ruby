require_relative './api_helper.rb'

module BayonetClient

  class DeviceFingerprint
    def self.get_fingerprint_data(params)
      BayonetClient::ApiHelper.request('/get-fingerprint-data', params)
    end
  end

end