source 'https://rubygems.org'

ruby '2.6.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'faker', '~> 1.9'
gem 'nokogiri', '~> 1.11'
gem 'haml-rails', '~> 1.0'
gem 'jbuilder', '~> 2.9'
gem 'mailgun_rails', '~> 0.9'
gem 'pg', '~> 1.1'
gem 'puma', '~> 3.12'
gem 'rails', '~> 5.2'
gem 'rubocop', '~> 0.71', require: false
gem 'rubocop-rails', '~> 2.0'
gem 'sass-rails', '~> 5.0'
gem 'seed-fu', '~> 2.3'
gem 'uglifier', '~> 4.1'
gem 'validates_email_format_of', '~> 1.6'

group :test, :development do
  gem 'capybara', '~> 2.18'
  gem 'dotenv-rails', '~> 2.7'
  gem 'factory_bot_rails', '~> 4.11'
  gem 'rspec-rails', '~> 3.8'
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  gem 'listen', '~> 3.1'
  gem 'pry', '~> 0.12'
  gem 'spring', '~> 2.1'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.7'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
