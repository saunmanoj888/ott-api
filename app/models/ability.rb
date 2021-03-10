# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # return unless user.present?
    # if user.is_admin?
    #   can :manage, Movie
    # else
    #   can :read, Movie
    # end
    # can :update, [Rating, Review], user_id: user.id
    return unless user.present?
    can :read, Movie
    can :update, [Rating, Review], user_id: user.id
    can :destroy, [Review], user_id: user.id
    return unless user.is_admin?
    can :manage, Movie
    can :destroy, [Review]
  end
end
