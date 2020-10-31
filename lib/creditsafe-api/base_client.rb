# frozen_string_literal: true

require 'faraday'
require 'json'
module Creditsafe
  module Api
    ##
    # Client connects to the creditsafe api and provides methods
    # matching API calls.
    class BaseClient
      include Creditsafe::Api::Utils
      attr_accessor :token
      def initialize(params)
        @username = params[:username]
        @password = params[:password]
        @loglevel = params[:loglevel] || Logger::WARN

        @environment = params[:environment] || :production
      end

      private

      def check_params(params)
        missing = MANDATORY_PARAMS.find_all{ |p| params[p].nil? }
        unexpected = params.reject { |k| EXPECTED_PARAMS.include?(k) }
        raise(IncorrectParams, "Missing params: #{missing}") unless missing.empty?
        raise(IncorrectParams, "Unexpected params: #{unexpected}") unless unexpected.empty?
      end

      def auth_header
        { 'Authorization' => @token }
      end

      def check_connected
        raise NotConnected if @token.nil?
      end
    end
  end
end
