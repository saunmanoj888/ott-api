class MovieAbility
  include CanCan::Ability
  def initialize(user)
    return unless user.present?
    can :read, Movie
    return unless user.is_admin?
    can :manage, Movie
  end
end
