class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :make_action_mailer_use_request_host_and_protocol
  helper_method :bool_to_unicode

  def bool_to_unicode(bool)
    bool ? "\u2714".encode('utf-8') : "\u2718".encode('utf-8')
  end

  private

    def make_action_mailer_use_request_host_and_protocol
      ActionMailer::Base.default_url_options[:protocol] = request.protocol
      ActionMailer::Base.default_url_options[:host] = request.host_with_port
    end
end
