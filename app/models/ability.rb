# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?
    @user = user
    initialize_abilities
  end

  def initialize_abilities
    movie_abilities
    review_abilities
    ratings_abilities
    user_abilities
  end

  def movie_abilities
    if @user.is_admin?
      can :manage, Movie
    else
      can :read, Movie
    end
  end

  def review_abilities
    can :destroy, Review if @user.is_admin? && @user.can_access?('can_delete_review')
    can :destroy, Review, user_id: @user.id if @user.can_access?('can_delete_review')
    can :update, Review, user_id: @user.id if @user.can_access?('can_edit_review')
    can :create, Review if @user.can_access?('can_create_review')
  end

  def ratings_abilities
    can :destroy, Rating if @user.is_admin? && @user.can_access?('can_delete_rating')
    can :update, Rating, user_id: @user.id if @user.can_access?('can_edit_rating')
    can :create, Rating if @user.can_access?('can_create_rating')
  end

  def user_abilities
    can :remove_permission, User if @user.is_admin?
  end
end
