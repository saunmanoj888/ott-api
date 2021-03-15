class ReviewAbility
  include CanCan::Ability
  def initialize(user)
    return unless user.present?
    can :create, Review if user.can_access?('can_create_review')
    can :update, Review, user_id: user.id if user.can_access?('can_edit_review')
    can :destroy, Review, user_id: user.id if user.can_access?('can_delete_review')
    return unless user.is_admin?
    can :destroy, Review if user.can_access?('can_delete_review')
  end
end
