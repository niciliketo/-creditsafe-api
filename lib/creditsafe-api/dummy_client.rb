# frozen_string_literal: true

require 'faraday'
require 'json'
require 'creditsafe-api/base_client'
module Creditsafe
  module Api
    ##
    # Dummy client returns canned responses and does not
    # connect to the creditsafe api.
    class DummyClient < BaseClient
      def connect
        @token = DUMMY_TOKEN
        true
      end

      def connected?
        !@token.nil?
      end

      def company_search(_params)
        check_connected
        file = File.read(get_path('company_search_success.json'))
        JSON.parse file
      end

      def company_credit_report(_connect_id)
        check_connected
        file = File.read(get_path("company_credit_report_success.json"))
        JSON.parse file
      end

      private

      def get_path(file)
        "#{__dir__}/../../dummy_responses/#{file}"
      end
    end
  end
end
