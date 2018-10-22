require 'httparty'
require_relative './bayonet_client/version'
require_relative './bayonet_client/response.rb'
require_relative './bayonet_client/exceptions.rb'
require_relative './bayonet_client/ecommerce.rb'
require_relative './bayonet_client/lending.rb'
require_relative './bayonet_client/device_fingerprint.rb'

module BayonetClient
  DEFAULT_HTTP_TIMEOUT = 10

  def self.configure(api_key, version, timeout = DEFAULT_HTTP_TIMEOUT)
    if version.nil? || version.empty?
      message = 'Please specify Api version'
      raise BayonetClient::BayonetError.new(nil, nil, nil, nil, -1, message)
    end
    if api_key.nil? || api_key.empty?
      message = 'Please specify Api key'
      raise BayonetClient::BayonetError.new(nil, nil, nil, nil, -1, message)
    end
    unless timeout.is_a? Numeric
      message = 'Please specify a valid timeout value'
      raise BayonetClient::BayonetError.new(nil, nil, nil, nil, -1, message)
    end
    unless BayonetClient::SUPPORTED_API_VERSIONS.include?(version)
      message = 'This library does not support the version specified. Please consider updating your dependencies'
      raise BayonetClient::BayonetError.new(nil, nil, nil, nil, -1, message)
    end

    @api_key = api_key
    @version = version
    @timeout = timeout
  end

  class << self
    attr_reader :api_key
    attr_reader :version
    attr_reader :timeout
  end

end
