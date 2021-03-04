module SessionsFilter
  extend ActiveSupport::Concern

  included do

    private

    def validate_login_params
      return json_response({ error: 'Please provide username and password' }, :unauthorized) if params[:user].blank?
    end

  end
end
