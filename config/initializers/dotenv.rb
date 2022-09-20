Bundler.require(*Rails.groups)
if ['development', 'test'].include? ENV['RAILS_ENV']
  Dotenv.require_keys(
    'ADMIN_PASSWORD', # password to enter admin pages at /admin
    'EMAIL_DOMAIN', # email domain to use for outgoing emails, eg 'example.com'
    'EMAIL_USER', # email user to use for outgoing emails, eg 'admin'
    'SPECIAL_EMAIL_DOMAIN', # email domain to use for outgoing special event emails, eg 'example.com'
    'SPECIAL_EMAIL_USER', # email user to use for outgoing special event emails, eg 'admin'
    'EVENT_ORGANIZER_USER', # email user to use for event organizer in invite ics files
    'EXCEPTIONS_EMAIL_ADDRESS', # email to which exception notifications shall be sent
    'HOST', # host for the deployed site. no leading protocol and no trailing slash. e.g: example.com
    'MAILGUN_API_KEY', # api key from mailgun.com
    'MAILING_LIST_NAME' # prefixes emails and stuff
  )
end
