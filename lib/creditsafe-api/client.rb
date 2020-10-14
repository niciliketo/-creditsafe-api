# frozen_string_literal: true

require 'faraday'
require 'json'
module Creditsafe
  module Api
    ##
    # Client connects to the creditsafe api and provides methods
    # matching API calls.
    class Client
      MANDATORY_PARAMS = %i[username password].freeze
      EXPECTED_PARAMS = %i[username password log_level environment].freeze
      SANDBOX_BASE_URL = 'https://connect.sandbox.creditsafe.com/v1'
      PRODUCTION_BASE_URL = 'https://connect.creditsafe.com/v1'
      AUTH_PATH = '/authenticate'
      COMPANY_SEARCH_PATH = '/companies'
      HEADERS = { 'Content-Type' => 'application/json' }
      def initialize(params)
        check_params(params)

        @username = params[:username]
        @password = params[:password]
        @loglevel = params[:loglevel] || Logger::DEBUG
        @environment = params[:environment] || 'production'
      end

      def connect
        url = build_url(AUTH_PATH)
        params = { username: @username, password: @password }.to_json
        Creditsafe::Api.logger.debug("Making request for token to #{url}")
        response = Faraday.post(url, params, HEADERS)
        Creditsafe::Api.logger.debug('Response received')
        response_json = JSON.parse response.body
        Creditsafe::Api.logger.debug("response: #{response_json}")
        @token = response_json['token']
        true
      end

      def company_search(params)
        check_connected
        url = build_url(COMPANY_SEARCH_PATH)
        response = Faraday.get(url, params, auth_header)
        Creditsafe::Api.logger.debug("response: #{response}")
        JSON.parse response.body
      end

      def company_credit_report(connect_id)
        check_connected
        url = build_url(COMPANY_SEARCH_PATH, connect_id)
        response = Faraday.get(url, {}, auth_header)
        Creditsafe::Api.logger.debug("Response received: #{response}")
        JSON.parse response.body
      end

      private

      def build_url(path, params = nil)
        base_url = @environment == 'production' ? PRODUCTION_BASE_URL : SANDBOX_BASE_URL
        url = "#{base_url}#{path}"
        url += "/#{params}" unless params.nil?
        url
      end

      def check_params(params)
        missing = MANDATORY_PARAMS.find_all{ |p| params[p].nil? }
        unexpected = params.reject{ |k| EXPECTED_PARAMS.include?(k) }
        raise(IncorrectParams, "Missing params: #{missing}") unless missing.empty?
        raise(IncorrectParams, "Unexpected params: #{unexpected}") unless unexpected.empty?
      end

      def auth_header
        {'Authorization' => @token}
      end

      def check_connected
        raise NotConnected if @token.nil?
      end
    end
  end
end
