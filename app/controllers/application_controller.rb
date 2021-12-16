class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :make_action_mailer_use_request_host_and_protocol
  helper_method :bool_to_unicode
  helper_method :ternary_to_unicode
  helper_method :bool_to_unicode_clean

  def bool_to_unicode(bool)
    bool ? "\u2714".encode('utf-8') : "\u2718".encode('utf-8')
  end

  def ternary_to_unicode(ternary)
    case ternary
    when 1
      "\u2797".encode('utf-8')
    when 2
      "\u2714".encode('utf-8')
    else
      "\u2718".encode('utf-8')
    end
  end

  def bool_to_unicode_clean(bool)
    bool ? "\u2714".encode('utf-8') : ''
  end

  private

    def make_action_mailer_use_request_host_and_protocol
      ActionMailer::Base.default_url_options[:protocol] = request.protocol
      ActionMailer::Base.default_url_options[:host] = request.host_with_port
    end

    def require_admin_login
      if not session[:admin]
        flash[:warning] = 'You must be logged in'
        redirect_to :admin_login
      end
    end
end
