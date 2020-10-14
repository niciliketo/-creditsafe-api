require 'faraday'
require 'json'
require 'logger'
module Creditsafe
  module Api
  ##
  # TODO:
  # 1. Make this a Gem
  # 2. Add logging
  # 3. Better error handling
  # 4. Specs
  # 5. Methods for other end points
  # 6. Documentation
  #
  # HOW TO :
  # Need username & password
  #
  # client = Creditsafe::Client.new(username: username, password: password)
  # client.connect
  # list = client.company_search({countries: 'GB', name: 'Market Dojo'})
  # company = client.company_credit_report( "GB-0-07332766")

    class << self
      attr_writer :logger

      def logger
        @logger ||= Logger.new($stdout).tap do |log|
          log.progname = self.name
        end
      end
    end

    class NotConnected < StandardError
      def initialize(msg="Please connect before making a request")
        super
      end
    end

    class Client
      MANDATORY_PARAMS = %i[username password].freeze
      EXPECTED_PARAMS = %i[username password log_level environment].freeze
      SANDBOX_BASE_URL = 'https://connect.sandbox.creditsafe.com/v1'.freeze
      PRODUCTION_BASE_URL = 'https://connect.creditsafe.com/v1'.freeze
      AUTH_PATH = '/authenticate'.freeze
      COMPANY_SEARCH_PATH = '/companies'.freeze
      HEADERS = { 'Content-Type' => 'application/json' }.freeze
      def initialize(params)
        puts params
        check = check_params(params)

        return check unless check.nil?

        @username = params[:username]
        @password = params[:password]
        @loglevel = params[:loglevel] || Logger::DEBUG
        @environment = params[:environment] || 'production'
      end

      def connect
        url = build_url(AUTH_PATH)
        params = {username: @username, password: @password }.to_json
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

      def token
        @token
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
        unexpected =  params.reject{ |k| EXPECTED_PARAMS.include?(k) }
        if missing.empty? && unexpected.empty?
          return nil
        else
          return "Missing params: #{missing}. Unexpected params: #{unexpected}"
        end
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
