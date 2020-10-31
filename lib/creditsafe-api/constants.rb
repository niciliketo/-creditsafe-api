# frozen_string_literal: true

module Creditsafe
  module Api
    # Some constants we use
    MANDATORY_PARAMS = %i[username password].freeze
    EXPECTED_PARAMS = %i[username password log_level environment].freeze
    SANDBOX_BASE_URL = 'https://connect.sandbox.creditsafe.com/v1'
    PRODUCTION_BASE_URL = 'https://connect.creditsafe.com/v1'
    AUTH_PATH = '/authenticate'
    COMPANY_SEARCH_PATH = '/companies'
    HEADERS = { 'Content-Type' => 'application/json' }.freeze

    # For dummy responses
    DUMMY_TOKEN ='abcd'
  end
end