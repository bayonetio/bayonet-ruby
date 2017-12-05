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

    @params_consulting = keys_to_symbols load_fixture('params_consulting')
    @params_feedback = keys_to_symbols load_fixture('params_feedback')
    @params_feedback_trans_code = keys_to_symbols load_fixture('params_feedback')
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

  describe 'ConsultingEndpoint' do
    it 'should return error on invalid api key' do
      BayonetClient.configure(@invalid_api_key, @api_version)
      expect{
        BayonetClient::Ecommerce.consulting(@params_consulting)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should validate api_key' do
      begin
        BayonetClient.configure(@invalid_api_key, @api_version)
        BayonetClient::Ecommerce.consulting(@params_consulting)
      rescue BayonetClient::BayonetError => e
        expect(e.reason_code).to eq(12)
      end
    end

    it 'should return success' do
      BayonetClient.configure(@api_key, @api_version)
      r = BayonetClient::Ecommerce.consulting(@params_consulting)
      @params_feedback_trans_code[:feedback_api_trans_code] = r.feedback_api_trans_code
      expect(r.reason_code).to eq(0)
    end

    it 'should return feedback_api_trans_code' do
      BayonetClient.configure(@api_key, @api_version)
      r = BayonetClient::Ecommerce.consulting(@params_consulting)
      expect(r.feedback_api_trans_code).to_not be_nil
    end
  end

  describe 'FeedbackEndpoint' do
    it 'should return error on invalid api key' do
      BayonetClient.configure(@invalid_api_key, @api_version)
      expect{
        BayonetClient::Ecommerce.feedback(@params_feedback)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should validate api_key' do
      BayonetClient.configure(@invalid_api_key, @api_version)
      begin
        BayonetClient::Ecommerce.feedback(@params_feedback)
      rescue BayonetClient::BayonetError => e
        expect(e.reason_code).to eq(12)
      end
    end

    it 'should return error on invalid feedback api trans code' do
      BayonetClient.configure(@api_key, @api_version)
      expect{
        BayonetClient::Ecommerce.feedback(@params_feedback)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should validate feedback api trans code' do
      BayonetClient.configure(@api_key, @api_version)
      begin
        BayonetClient::Ecommerce.feedback(@params_feedback)
      rescue BayonetClient::BayonetError => e
        expect(e.reason_code).to eq(87)
      end
    end

    it 'should return success on feedback' do
      BayonetClient.configure(@api_key, @api_version)
      r = BayonetClient::Ecommerce.feedback(@params_feedback_trans_code)
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
  end

  describe 'GetFingerprintDataEndpoint' do
    it 'should return error on invalid api key' do
      BayonetClient.configure(@invalid_api_key, @api_version)
      expect{
        BayonetClient::DeviceFingerprint.get_fingerprint_data(@params_get_fingerprint_data)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should return error on invalid bayonet fingerprint token' do
      begin
        BayonetClient.configure(@api_key, @api_version)
        BayonetClient::DeviceFingerprint.get_fingerprint_data(@params_get_fingerprint_data)
      rescue BayonetClient::BayonetError => e
        expect(e.reason_message).to eq('Error: Invalid value for bayonet_fingerprint_token')
      end
    end
  end

end