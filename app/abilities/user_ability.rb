class UserAbility
  include CanCan::Ability
  def initialize(user)
    return unless user.present?
    can [:remove_permission, :assign_permission], User if user.is_admin?
  end
end
