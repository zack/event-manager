source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'figaro', '~> 1.1'
gem 'haml-rails', '~> 1.0'
gem 'jbuilder', '~> 2.7'
gem 'mailgun_rails', '~> 0.9'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.1'
gem 'sass-rails', '~> 5.0'
gem 'sqlite3', '~> 1.3'
gem 'uglifier', '~> 4.0'
gem 'validates_email_format_of', '~> 1.6'

group :development, :test do
  gem 'pry', '~> 0.11'
  gem 'capybara', '~> 2.16'
end

group :development do
  gem 'listen', '~> 3.1'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.5'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
