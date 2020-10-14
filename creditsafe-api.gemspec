# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'creditsafe-api'
  s.version     = '0.0.0'
  s.date        = '2020-10-13'
  s.summary     = 'Ruby wrapper to the Creditsafe REST API'
  s.description = 'Ruby wrapper to the Creditsafe REST API'
  s.authors     = ['Nic Martin']
  s.email       = 'niholas.martink@marketdojo.com'
  s.files       = ['lib/creditsafe-api.rb', 'lib/creditsafe-api/client.rb', 'lib/creditsafe-api/errors.rb',
                   'lib/creditsafe-api/logger.rb']
  s.homepage    = 'https://github.com/marketdojo/creditsafe-api'
  s.license     = 'MIT'

  s.add_runtime_dependency 'faraday', '~> 1.0'
end