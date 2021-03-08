module Api
  module V1
    class SessionsController < ApplicationController
      include SessionsFilter

      skip_before_action :authorize_user, only: [:create]
      before_action :validate_login_params, only: [:create]

      def create
        @user = User.find_by(email: params[:user][:email])

        if @user&.authenticate(params[:user][:password])
          json_response({
            user:  @user.as_json(only: [:id, :email]),
            token: JsonWebToken.encode({ user_id: @user.id })
          })
        else
          json_response({ error: 'Invalid username or password' }, :unauthorized)
        end
      end

    end
  end
end
