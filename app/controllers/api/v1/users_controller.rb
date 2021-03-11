module Api
  module V1
    class UsersController < ApplicationController
      load_and_authorize_resource only: :remove_permission

      skip_before_action :authorize_user, only: :create
      before_action :find_permission, only: :remove_permission

      def create
        @user = User.new(user_params)
        if @user.save
          json_response(@user, :created)
        else
          json_response({ error: @user.errors.full_messages }, :bad_request)
        end
      end

      def remove_permission
        if @user.permissions.destroy(@permission)
          json_response({ message: 'Permission removed successfully' })
        else
          json_response({ error: 'Unable to remove permission' }, :bad_request)
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end

      def find_permission
        @permission = Permission.find_by!(name: params[:user][:permission])
      end

    end
  end
end
