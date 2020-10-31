require 'minitest/autorun'
require 'creditsafe-api'
require 'vcr'
module Creditsafe
  class ApiTest < Minitest::Test
    VCR.configure do |config|
      config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
      config.hook_into :webmock
    end

    def setup
      Creditsafe::Api.logger.level = Logger::INFO
    end

    def test_initialize_success
      client = Creditsafe::Api::Client.new(username: 'foo', password: 'bar', environment: :sandbox)
      assert_equal %i[@username @password @loglevel @environment @proxy],
                   client.instance_variables
    end

    def test_initialize_wrong_param
      assert_raises Creditsafe::Api::IncorrectParams do
        Creditsafe::Api::Client.new(username: 'foo', password: 'bar', environmen: :sandbox)
      end
    end

    def test_initialize_missing_param
      assert_raises Creditsafe::Api::IncorrectParams do
        Creditsafe::Api::Client.new(username: 'foo')
      end
    end

    def test_authenticate_response
      VCR.use_cassette('connect') do
        client = Creditsafe::Api::Client.new(username: 'user', password: 'pass', environment: :production)
        client.connect
        assert client.connected?
      end
    end

    def test_company_search_response
      VCR.use_cassette('search') do
        client = Creditsafe::Api::Client.new(username: 'user', password: 'pass', environment: :production)
        client.connect
        result = client.company_search(countries: 'GB', name: 'market')
        assert_equal '89f77f70-1b59-11eb-ab4b-06a7a8cd954f', result['correlationId'], 'Incorrect id returned'
      end
    end

    def test_company_credit_report_response
      VCR.use_cassette('report') do
        client = Creditsafe::Api::Client.new(username: 'user', password: 'pass', environment: :production)
        client.connect
        result = client.company_credit_report('GB-0-07332766')
        assert_equal 'MARKET DOJO LTD', result['report']['companySummary']['businessName']
      end
    end

    def test_can_assign_log_level
      Creditsafe::Api.logger.level = Logger::FATAL
      assert_equal 4, Creditsafe::Api.logger.level
    end
  end
end
