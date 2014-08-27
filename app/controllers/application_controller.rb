class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :check_authentication_param, :try_cas_gateway_login, :set_no_cache
  after_action :verify_authorized, except: [:landing, :search]
  after_action :verify_policy_scoped, only: :index
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied!

  helper_method :current_user
  def current_user
    authentication.authenticated_user
  end

  def user_logged_in?
    authentication.perform
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

  def get_object(klass)
    object = params[:id] ? klass.any_of({id: params[:id]}, {slug: params[:id]}).first : nil
    if object.blank? || object.dont_index?
      render_error_page(404)
      nil
    else
      object
    end
  end

  def set_object
    instance_variable_set "@#{params[:controller].singularize}", get_object(params[:controller].classify.constantize)
  end

  # There is a bug when pushing history state after clicking on a remote:true link, then when you hit the back
  #   button you see the javascript code to update the page instead of the actual page. This expires js responses
  #   so that the browser doesn't cache those pages.
  def set_no_cache
    if request.format.symbol == :js
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  end

end
