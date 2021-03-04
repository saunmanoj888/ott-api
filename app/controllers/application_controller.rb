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
end
