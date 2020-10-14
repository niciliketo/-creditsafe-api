require 'minitest/autorun'
require 'creditsafe-api'

class Creditsafe::ApiTest < Minitest::Test
  def test_initialize_success
    client = Creditsafe::Api::Client.new(username: 'foo', password: 'bar', environment: :sandbox, log_level: :debug)
    assert_equal %i[@username @password @loglevel @environment],
                 client.instance_variables
  end

  def test_initialize_wrong_param
    assert_raises Creditsafe::Api::IncorrectParams do
      Creditsafe::Api::Client.new(username: 'foo', password: 'bar', environmen: :sandbox, log_level: :debug)
    end
  end

  def test_initialize_missing_param
    assert_raises Creditsafe::Api::IncorrectParams do
      Creditsafe::Api::Client.new(username: 'foo')
    end
  end
end
