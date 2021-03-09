module Api
  module V1
    class UsersController < ApplicationController

      skip_before_action :authorize_user, only: [:create]

      def create
        @user = User.new(user_params)
        if @user.save
          json_response(@user, :created)
        else
          json_response({ error: @user.errors.full_messages }, :bad_request)
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end

    end
  end
end
