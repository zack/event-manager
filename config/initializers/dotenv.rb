Bundler.require(*Rails.groups)
if ['development', 'test'].include? ENV['RAILS_ENV']
  Dotenv.require_keys(
    'MAILGUN_API_KEY',
    'MAILING_LIST_NAME',
    'EMAIL_USER',
    'EMAIL_DOMAIN',
    'ADMIN_PASSWORD'
  )
end
