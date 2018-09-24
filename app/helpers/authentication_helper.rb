module AuthenticationHelper

  def authenticate_user
    auth_token = request.headers["X-Auth-Token"].presence || params[:auth_token].presence
    @current_user = User.where(auth_token: auth_token).first if auth_token.present?
  end

  def current_user
    @current_user
  end

end