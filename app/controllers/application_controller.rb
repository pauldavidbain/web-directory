class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_authentication_param, :try_cas_gateway_login
  after_action :verify_authorized, except: [:landing, :search]
  after_action :verify_policy_scoped, only: :index
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied!

  helper_method :current_user
  def current_user
    authentication.user
  end

  def user_logged_in?
    current_user.present?
  end


  protected

  def check_authentication_param
    if params[:login] == 'true' && !user_logged_in?
      authenticate!
      false
    end
  end

  def try_cas_gateway_login
    unless user_logged_in? || session[:gateway_login_attempted] || Rails.env.test?
      cas_server = RackCAS::Server.new(Settings.cas.url)

      session[:gateway_login_attempted] = true
      redirect_to cas_server.login_url(request.url, gateway: true).to_s
    end
  end

  def authenticate!
    authentication.perform or render_error_page(401)
  end

  def authentication
    @authentication ||= CasAuthentication.new(session)
  end

  def permission_denied!
    render_error_page(user_logged_in? ? 403 : 401)
  end
  alias :permission_denied :permission_denied!

  def render_error_page(status)
    render file: "#{Rails.root}/public/#{status}", formats: [:html], status: status, layout: false
  end

end
