module Commentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, as: :commentable, dependent: :destroy
  end

  def create_comment(user)
    comments.create(user: user)
  end

  def delete_comment(user)
    comments.where(user: user).destroy_all if commented_by?(user)
  end

  def commented_by?(user)
    comments.exists?(user: user)
  end
end
