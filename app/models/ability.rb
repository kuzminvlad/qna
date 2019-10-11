# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user
    can :set_best, Answer

    can :vote_up, [Question, Answer]
    cannot :vote_up, [Question, Answer], user: user
    can :vote_down, [Question, Answer]
    cannot :vote_down, [Question, Answer], user: user
    can :delete_vote, [Question, Answer]
    cannot :delete_vote, [Question, Answer], user: user
  end
end
