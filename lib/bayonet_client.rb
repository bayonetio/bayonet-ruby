require 'httparty'
require_relative './bayonet_client/version'
require_relative './bayonet_client/response.rb'
require_relative './bayonet_client/exceptions.rb'
require_relative './bayonet_client/ecommerce.rb'
require_relative './bayonet_client/lending.rb'

module BayonetClient

  def self.configure(api_key, version)
    if version.nil? || version.empty?
      message = 'Please specify Api version'
      raise BayonetClient::InvalidClientSetupError.new message
    end
    if api_key.nil? || api_key.empty?
      message = 'Please specify Api key'
      raise BayonetClient::InvalidClientSetupError.new message
    end
    unless BayonetClient::SUPPORTED_API_VERSIONS.include?(version)
      message = 'This library does not support the version specified. Please consider updating your dependencies'
      raise BayonetClient::InvalidClientSetupError.new message
    end

    @api_key = api_key
    @version = version
  end

  class << self
    attr_reader :api_key
    attr_reader :version
  end

end
