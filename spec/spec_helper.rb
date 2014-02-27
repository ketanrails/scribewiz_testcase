require 'rubygems'
require 'bundler/setup'
require 'rspec'
require 'capybara/rspec'
require 'capybara/poltergeist'

# Capybara configuration

Capybara.configure do |config|
  config.default_wait_time = 20
  config.run_server = false
  config.default_driver = :poltergeist
  config.app_host = 'http://app.scribewiz.com:3000'
end
