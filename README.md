# creditsafe-api

A ruby library for interacting with the
[Creditsafe](http://www.creditsafe.com/) REST [API](https://www.creditsafe.com/gb/en/enterprise/integrations/api-documentation.html).

Currently, it only partially implements the API to support finding companies, and retrieving company online reports.

# Installation

Install the gem from Github by adding the following to your `Gemfile`:

```ruby
gem 'creditsafe-api', git: 'https://github.com/niciliketo/creditsafe-api.git'
```

Just run `bundle install` to install the gem and its dependencies.

# Usage

Initialise the client with your `username` and `password`.

```ruby
client = Creditsafe::Api::Client.new(username: 'foo', password: 'bar')

# optionally with environment (production is default) and or log level
client = Creditsafe::Client.new(username: 'foo', password: 'bar', environment: :sandbox, log_level: :debug)
```
### Connecting

Before using the API, you need to connect

```ruby
client.connect
```
### Company Search

To perform a search for a company, you need to provide valid search criteria:

```ruby
client.company_search({countries: 'GB', name: 'Market Dojo'})
=> {
    ...
   }
```


### Company Credit Report

To download all the information available in an online company report, you will
need the company's Creditsafe identifier (obtainable using
[find_company](#find_company) above):

```ruby
client.company_credit_report('GB-0-07332766')
=> {
    ...
   }
```
# Dummy environment

It is not always convenient to send real requests to either the production or sandbox environment.

In this case you can pass `environment: :dummy` to the connect method.
This will use the responses stored in the dummy_responses folder.

# Tests
Run the tests with...
```ruby
rake test
```
### Credits

Thanks to [GoCardless](https://gocardless.com/) for the [creditsafe-ruby gem](https://github.com/gocardless/creditsafe-ruby) which much of this work is based upon.

---
