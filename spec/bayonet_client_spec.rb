require 'spec_helper'

def load_fixture(name)
  fixtures = YAML.load_file File.join(File.dirname(__FILE__), 'fixtures/api_params.yaml')
  fixtures[name]
end

def keys_to_symbols(hash)
  hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
end

describe BayonetClient do

  before :all do
    @api_key = ENV['api_key']
    @api_version = ENV['api_version']

    if @api_key.nil?
      raise 'Please set api_key environment variable to run the tests'
    end
    if @api_version.nil?
      raise 'Please set api_version environment variable to run the tests'
    end

    @invalid_api_key = load_fixture('invalid_api_key')
    # generate a random transaction id
    @transaction_id = (0...8).map { (65 + rand(26)).chr }.join
    @params_consult = keys_to_symbols load_fixture('params_consult')
    @params_update_transaction = keys_to_symbols load_fixture('params_update_transaction')
    @params_feedback_historical = keys_to_symbols load_fixture('params_feedback_historical')
    @params_get_fingerprint_data = keys_to_symbols load_fixture('params_get_fingerprint_data')
  end

  describe 'ClientSetup' do
    it 'cannot instantiate with empty api version' do
      expect{
        BayonetClient.configure('xxx', '')
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'cannot instantiate with invalid api version' do
      expect{
        BayonetClient.configure('xxx', '54')
      }.to raise_error(BayonetClient::BayonetError)
    end
  end

  describe 'ConsultEndpoint' do
    it 'should return error on invalid api key' do
      BayonetClient.configure(@invalid_api_key, @api_version)
      expect{
        BayonetClient::Ecommerce.consult(@params_consult)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should validate api_key' do
      begin
        BayonetClient.configure(@invalid_api_key, @api_version)
        BayonetClient::Ecommerce.consult(@params_consult)
      rescue BayonetClient::BayonetError => e
        expect(e.reason_code).to eq(12)
      end
    end

    it 'should return success' do
      @params_consult[:transaction_id] = @transaction_id
      BayonetClient.configure(@api_key, @api_version)
      r = BayonetClient::Ecommerce.consult(@params_consult)
      expect(r.reason_code).to eq(0)
    end
  end

  describe 'TransactionUpdateEndpoint' do
    it 'should return error on invalid api key' do
      BayonetClient.configure(@invalid_api_key, @api_version)
      expect{
        BayonetClient::Ecommerce.update_transaction(@params_update_transaction)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should validate api_key' do
      BayonetClient.configure(@invalid_api_key, @api_version)
      begin
        BayonetClient::Ecommerce.update_transaction(@params_update_transaction)
      rescue BayonetClient::BayonetError => e
        expect(e.reason_code).to eq(12)
      end
    end

    it 'should return success' do
      @params_update_transaction[:transaction_id] = @transaction_id
      BayonetClient.configure(@api_key, @api_version)
      r = BayonetClient::Ecommerce.update_transaction(@params_update_transaction)
      expect(r.reason_code).to eq(0)
    end

  end

  describe 'FeedbackHistoricalEndpoint' do
    it 'should return error on invalid api key' do
      BayonetClient.configure(@invalid_api_key, @api_version)
      expect{
        BayonetClient::Ecommerce.feedback_historical(@params_feedback_historical)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should validate api_key' do
      BayonetClient.configure(@invalid_api_key, @api_version)
      begin
        BayonetClient::Ecommerce.feedback_historical(@params_feedback_historical)
      rescue BayonetClient::BayonetError => e
        expect(e.reason_code).to eq(12)
      end
    end

    it 'should return success' do
      # generate a random order id
      order_id = (0...8).map { (65 + rand(26)).chr }.join
      @params_feedback_historical[:order_id] = order_id
      BayonetClient.configure(@api_key, @api_version)
      r = BayonetClient::Ecommerce.feedback_historical(@params_feedback_historical)
      expect(r.reason_code).to eq(0)
    end
  end

  # describe 'GetFingerprintDataEndpoint' do
  #   it 'should return error on invalid api key' do
  #     BayonetClient.configure(@invalid_api_key, @api_version)
  #     expect{
  #       BayonetClient::DeviceFingerprint.get_fingerprint_data(@params_get_fingerprint_data)
  #     }.to raise_error(BayonetClient::BayonetError)
  #   end
  #
  #   it 'should return error on invalid bayonet fingerprint token' do
  #     begin
  #       BayonetClient.configure(@api_key, @api_version)
  #       BayonetClient::DeviceFingerprint.get_fingerprint_data(@params_get_fingerprint_data)
  #     rescue BayonetClient::BayonetError => e
  #       expect(e.reason_message).to eq('Error: Invalid value for bayonet_fingerprint_token')
  #     end
  #   end
  # end

end