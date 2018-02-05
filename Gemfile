source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'faker', '~> 1.8'
gem 'figaro', '~> 1.1'
gem 'haml-rails', '~> 1.0'
gem 'jbuilder', '~> 2.7'
gem 'mailgun_rails', '~> 0.9'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.1'
gem 'rubocop', '~> 0.52', require: false
gem 'sass-rails', '~> 5.0'
gem 'seed-fu', '~> 2.3'
gem 'sqlite3', '~> 1.3'
gem 'uglifier', '~> 4.1'
gem 'validates_email_format_of', '~> 1.6'

group :test, :development do
  gem 'capybara', '~> 2.17'
  gem 'factory_bot_rails', '~> 4.8'
  gem 'rspec-rails', '~> 3.7'
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  gem 'listen', '~> 3.1'
  gem 'pry', '~> 0.11'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.5'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
