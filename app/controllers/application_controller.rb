class ApplicationController < ActionController::Base
  before_filter :set_current_user, :check_authentication_param, :try_cas_gateway_login

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected

  def set_current_user
    Authorization.current_user = current_user
  end

  def check_authentication_param
    if params[:login] == 'true' && !user_logged_in?
      authenticate_user!
      false
    end
  end

  def try_cas_gateway_login
    unless user_logged_in? || session[:gateway_login_attempted] || params[:embedded] || Rails.env.test?
      cas_server = RackCAS::Server.new(Settings.cas.url)

      session[:gateway_login_attempted] = true
      redirect_to cas_server.login_url(request.url, gateway: true).to_s
    end
  end

  def authenticate_user!
    render_error_page 401 unless user_logged_in?
  end

  def current_user
    return @current_user unless @current_user.nil?

    username = session[:username] || session['cas'].try(:[], 'user')
    cas_attrs = session['cas'].try(:[], 'extra_attributes') || {}

    return nil if username.nil?

    @current_user = User.find_or_initialize_by_username(username).tap do |user|
      if !session[:username] # first time returning from CAS
        user.update_from_cas! cas_attrs unless Rails.env.test?
        user.update_login_info!
      end

      if user.new_record?
        user = nil
      else
        session[:username] = user.username
      end
    end
  end

  def user_logged_in?
    current_user.present?
  end

  def permission_denied!
    render_error_page(user_logged_in? ? 403 : 401)
  end
  alias :permission_denied :permission_denied!

  def render_error_page(status)
    render file: "#{Rails.root}/public/#{status}", formats: [:html], status: status, layout: false
  end

end
