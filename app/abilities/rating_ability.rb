class RatingAbility
  include CanCan::Ability
  def initialize(user)
    return unless user.present?
    can :create, Rating if user.can_access?('can_create_rating')
    can :update, Rating, user_id: user.id if user.can_access?('can_edit_rating')
    return unless user.is_admin?
    can :destroy, Rating if user.can_access?('can_delete_rating')
  end
end
