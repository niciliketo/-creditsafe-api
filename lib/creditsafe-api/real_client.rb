# frozen_string_literal: true

require 'faraday'
require 'json'
require 'creditsafe-api/base_client'
module Creditsafe
  module Api
    ##
    # Real client makes real calls to connects to the creditsafe api.
    class RealClient < BaseClient
      def connect
        url = build_url(AUTH_PATH)
        params = { username: @username, password: @password }.to_json
        Creditsafe::Api.logger.debug("Making request for token to #{url}")
        response = Faraday.post(url, params, HEADERS)
        Creditsafe::Api.logger.debug('Response received')
        Creditsafe::Api.logger.debug("Response: #{response.body}")
        response_json = JSON.parse response.body
        Creditsafe::Api.logger.debug("response: #{response_json}")
        @token = response_json['token']
        true
      end

      def connected?
        !@token.nil?
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
    end
  end
end
