class Question < ApplicationRecord
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

  belongs_to :user

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  after_create :update_reputation, :autosubscribe_for_own

  def to_s
    self[:title]
  end

  private

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end

  def autosubscribe_for_own
    user.subscribe!(id)
  end
end
