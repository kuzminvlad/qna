module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def vote_up(user)
    votes.create(user: user, value: 1) unless voted_by?(user)
  end

  def vote_down(user)
    votes.create(user: user, value: -1) unless voted_by?(user)
  end

  def delete_vote(user)
    votes.where(user: user).destroy_all if voted_by?(user)
  end

  def voted_by?(user)
    votes.exists?(user: user)
  end

  def total_score
    votes.sum(:value)
  end
end
