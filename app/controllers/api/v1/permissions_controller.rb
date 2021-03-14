module Api
  module V1
    class PermissionsController < ApplicationController
      load_and_authorize_resource only: %i[create destroy]

      def create
        if @permission.save
          json_response(@permission, :created)
        else
          json_response({ error: @permission.errors.full_messages }, :bad_request)
        end
      end

      def destroy
        if @permission.destroy
          json_response({ message: 'Permission destroyed successfully' })
        else
          json_response({ error: @permission.errors.full_messages }, :bad_request)
        end
      end

      private

      def permission_params
        params.require(:permission).permit(:name)
      end

      def current_ability
        @current_ability ||= PermissionAbility.new(current_user)
      end
    end
  end
end
