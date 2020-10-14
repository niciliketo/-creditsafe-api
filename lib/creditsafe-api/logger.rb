# frozen_string_literal: true

require 'logger'
require 'creditsafe-api/client'
##
# Outer namespace to Creditsafe::API
module Creditsafe
  ##
  # Inner namespace to Creditsafe::API
  module Api
    class << self
      attr_writer :logger

      def logger
        @logger ||= Logger.new($stdout).tap do |log|
          log.progname = name
        end
      end
    end
  end
end
