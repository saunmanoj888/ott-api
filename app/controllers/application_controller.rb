class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler

  before_action :authorize_user

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    return unless auth_header

    begin
      JsonWebToken.decode(auth_header.split(' ')[1])
    rescue JWT::DecodeError
      nil
    end
  end

  def logged_in_user
    return if decoded_token.blank?

    @logged_in_user = User.find_by(id: decoded_token[0]['user_id'])
  end

  def logged_in?
    !!logged_in_user
  end

  def authorize_user
    return if logged_in?

    json_response({ error: 'Please log in' }, :unauthorized)
  end

  def current_user
    @current_user ||= @logged_in_user
  end

  DEFAULT_PAGE = 1
  def page
    @page ||= params[:page] || DEFAULT_PAGE
  end

  DEFAULT_PER_PAGE = 20
  def per_page
    @per_page ||= params[:per_page] || DEFAULT_PER_PAGE
  end
end
