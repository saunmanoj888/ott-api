module PermissionHelper
  def create_admin_applicable_permissions
    Permission::List::ADMIN_APPLICABLE.each do |permission|
      create(:permission, name: permission)
    end
  end
end
