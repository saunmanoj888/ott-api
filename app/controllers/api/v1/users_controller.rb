module Api
  module V1
    class UsersController < ApplicationController
      load_and_authorize_resource only: %i[remove_permission assign_permission]

      skip_before_action :authorize_user, only: :create
      before_action :find_user_permission, only: :remove_permission
      before_action :find_permission, only: :assign_permission

      def create
        @user = User.new(user_params)
        if @user.save
          json_response(@user, :created)
        else
          json_response({ error: @user.errors.full_messages }, :bad_request)
        end
      end

      def remove_permission
        if @user_permission && @user.permissions.destroy(@user_permission)
          json_response({ message: 'Permission removed successfully' })
        else
          json_response({ error: 'Could not find Permission for the User' }, :not_found)
        end
      end

      def assign_permission
        user_permission = UsersPermission.new(user: @user, permission: @permission)
        if user_permission.save
          json_response({ message: 'Permission assigned successfully' })
        else
          json_response({ error: user_permission.errors.full_messages }, :bad_request)
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
      end

      def find_user_permission
        @user_permission = @user.permissions.find_by(name: params[:user][:permission])
      end

      def current_ability
        @current_ability ||= UserAbility.new(current_user)
      end

      def find_permission
        @permission = Permission.find_by(name: params[:user][:permission])
      end

    end
  end
end
