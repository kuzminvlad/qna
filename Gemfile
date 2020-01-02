source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2.3'

gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'jbuilder', '~> 2.5'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

gem 'active_model_serializers'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'oj'
gem 'oj_mimic_json'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'doorkeeper', '4.2.6'

gem 'bootstrap3-rails'
gem 'cancancan'
gem 'carrierwave'
gem 'cocoon'
gem 'jquery-datatables'
gem 'mysql2'
gem 'omniauth'
gem 'omniauth-github'
gem 'responders'
gem 'sidekiq'
gem 'sidetiq'
gem 'sinatra', '>=1.3.0', require: nil
gem 'slim-rails'
gem 'thinking-sphinx'
gem 'whenever'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'guard'
  gem 'guard-bundler', require: false
  gem 'guard-rspec', require: false
  # Checks ruby code grammar
  gem 'rubocop', require: false
  # With rspec
  gem 'rubocop-rspec'
  # With guard
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'guard-rubocop'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'rubocop-rails'
  gem 'selenium-webdriver'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'solargraph'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~>2.0'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
  gem 'json_spec'
  gem 'launchy'
  gem 'shoulda-matchers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
