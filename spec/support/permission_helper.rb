module PermissionHelper
  def create_applicable_permissions(permissions)
    permissions.each do |permission|
      create(:permission, name: permission)
    end
  end
end
