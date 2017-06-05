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
    api_key = ENV['api_key']
    api_version = ENV['api_version']

    if api_key.nil?
      raise 'Please set api_key environment variable to run the tests'
    end
    if api_version.nil?
      raise 'Please set api_version environment variable to run the tests'
    end

    @client = BayonetClient::Client.new(api_key, api_version)
    invalid_api_key = load_fixture('invalid_api_key')
    @invalid_client = BayonetClient::Client.new(invalid_api_key, api_version)

    @params_consulting = keys_to_symbols load_fixture('params_consulting')
    @params_feedback = keys_to_symbols load_fixture('params_feedback')
    @params_feedback_historical = keys_to_symbols load_fixture('params_feedback_historical')
    @params_chargeback_feedback = keys_to_symbols load_fixture('params_chargeback_feedback')
    @params_get_fingerprint_data = keys_to_symbols load_fixture('params_get_fingerprint_data')

  end

  describe 'ClientSetup' do
    it 'cannot instantiate with empty api version' do
      expect{
        BayonetClient::Client.new('', '2')
      }.to raise_error(BayonetClient::InvalidClientSetupError, 'This library does not support version specified. Consider updating your dependencies')
    end

    it 'cannot instantiate with invalid api version' do
      expect{
        BayonetClient::Client.new('', '')
      }.to raise_error(BayonetClient::InvalidClientSetupError, 'Please specify Api version')
    end
  end

  describe 'ConsultingEndpoint' do
    it 'should return error on invalid api key' do
      expect{
        @invalid_client.consulting(@params_consulting)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should validate api_key' do
      begin
        @invalid_client.consulting(@params_consulting)
      rescue BayonetClient::BayonetError => e
        expect(e.reason_code).to eq('11')
      end
    end

    it 'should return success' do
      r = @client.consulting(@params_consulting)
      expect(r.reason_code).to eq('00')
      params_feedback_copy = @params_feedback.clone
      params_feedback_copy[:feedback_api_trans_code] = r.feedback_api_trans_code
      r_f = @client.feedback(params_feedback_copy)
      expect(r_f.reason_code).to eq('00')
    end

    it 'should return feedback_api_trans_code' do
      r = @client.consulting(@params_consulting)
      expect(r.feedback_api_trans_code).to_not be_nil
    end
  end

  describe 'FeedbackEndpoint' do
    it 'should return error on invalid api key' do
      expect{
        @invalid_client.feedback(@params_feedback)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should validate api_key' do
      begin
        @invalid_client.feedback(@params_feedback)
      rescue BayonetClient::BayonetError => e
        expect(e.reason_code).to eq('11')
      end
    end

    it 'should return error on invalid feedback api trans code' do
      expect{
        @client.feedback(@params_feedback)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should validate feedback api trans code' do
      begin
        @client.feedback(@params_feedback)
      rescue BayonetClient::BayonetError => e
        expect(e.reason_code).to eq('87')
      end
    end

  end

  describe 'FeedbackHistoricalEndpoint' do
    it 'should return error on invalid api key' do
      expect{
        @invalid_client.feedback_historical(@params_feedback_historical)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should validate api_key' do
      begin
        @invalid_client.feedback_historical(@params_feedback_historical)
      rescue BayonetClient::BayonetError => e
        expect(e.reason_code).to eq('11')
      end
    end

    it 'should return success on chargeback feedback' do
      r = @client.feedback_historical(@params_chargeback_feedback)
      expect(r.reason_code).to eq('00')
    end

    it 'should return success' do
      r = @client.feedback_historical(@params_feedback_historical)
      expect(r.reason_code).to eq('00')
    end
  end

  describe 'GetFingerprintDataEndpoint' do
    it 'should return error on invalid api key' do
      expect{
        @invalid_client.get_fingerprint_data(@params_get_fingerprint_data)
      }.to raise_error(BayonetClient::BayonetError)
    end

    it 'should return error on invalid bayonet fingerprint token' do
      begin
        @invalid_client.get_fingerprint_data(@params_get_fingerprint_data)
      rescue BayonetClient::BayonetError => e
        expect(e.status).to eq('Error: Invalid value for bayonet_fingerprint_token')
      end
    end
  end

end