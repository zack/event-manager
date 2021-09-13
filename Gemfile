source 'https://rubygems.org'

ruby '3.0.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'faker', "~> 2.19"
gem 'nokogiri', "~> 1.12"
gem 'haml-rails', "~> 2.0"
gem 'jbuilder', "~> 2.11"
gem 'mailgun-ruby', "~> 1.2"
gem 'pg', "~> 1.2"
gem 'puma', "~> 5.4"
gem 'rails', "~> 6.1"
gem 'rubocop', "~> 1.21", require: false
gem 'rubocop-rails', "~> 2.12"
gem 'sass-rails', "~> 6.0"
gem 'seed-fu', "~> 2.3"
gem 'uglifier', "~> 4.2"
gem 'validates_email_format_of', "~> 1.6"

group :test, :development do
  gem 'capybara', "~> 3.35"
  gem 'dotenv-rails', "~> 2.7"
  gem 'factory_bot_rails', "~> 6.2"
  gem 'rspec-rails', "~> 5.0"
  gem 'shoulda-matchers', "~> 5.0"
end

group :development do
  gem 'listen', "~> 3.7"
  gem 'pry', "~> 0.14"
  gem 'spring', "~> 2.1"
  gem 'spring-watcher-listen', "~> 2.0"
  gem 'web-console', "~> 4.1"
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
