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
      def logger
        @@logger ||= defined?(Rails.logger) ? Rails.logger : Logger.new($stdout)
      end

      def logger=(logger)
        @@logger = logger
      end
    end
  end
end
