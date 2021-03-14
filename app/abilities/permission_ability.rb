class PermissionAbility
  include CanCan::Ability
  def initialize(user)
    return unless user.present?
    can [:create, :destroy], Permission if user.is_admin?
  end
end
