# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, Movie
    else
      can :read, Movie
    end
    can :update, [Rating, Review], user_id: user.id
  end
end
