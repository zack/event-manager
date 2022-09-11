source 'https://rubygems.org'

ruby '3.1.2'

git_source(:github) do |repo_name|
  repo_name = '#{repo_name}/#{repo_name}' unless repo_name.include?('/')
  'https://github.com/#{repo_name}.git'
end


gem 'bcrypt', "~> 3.1"
gem 'exception_notification', "~> 4.5"
gem 'flatpickr_rails', "~> 1.1"
gem 'haml-rails', "~> 2.0"
gem 'icalendar', "~> 2.8"
gem 'jbuilder', "~> 2.11"
gem 'mailgun-ruby', "~> 1.2"
gem 'nokogiri', "~> 1.13"
gem 'pg', "~> 1.4"
gem 'puma', "~> 5.6"
gem 'rails', "~> 7.0"
gem 'rubocop', "~> 1.36", require: false
gem 'rubocop-rails', "~> 2.16"
gem 'sass-rails', "~> 6.0"
gem 'seed-fu', "~> 2.3"
gem 'uglifier', "~> 4.2"
gem 'validates_email_format_of', "~> 1.7"

group :test, :development do
  gem 'capybara', "~> 3.37"
  gem 'dotenv-rails', "~> 2.8"
  gem 'execjs', "~> 2.8"
  gem 'factory_bot_rails', "~> 6.2"
  gem 'faker', "~> 2.23"
  gem 'mini_racer', "~> 0.6"
  gem 'rspec-rails', "~> 5.1"
  gem 'rspec_junit_formatter', "~> 0.5"
  gem 'rubocop-rspec', "~> 2.12"
  gem 'shoulda-matchers', "~> 5.1"
end

group :development do
  gem 'listen', "~> 3.7"
  gem 'pry', "~> 0.14"
  gem 'spring', "~> 2.1"
  gem 'spring-watcher-listen', "~> 2.0"
  gem 'web-console', "~> 4.2"
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
