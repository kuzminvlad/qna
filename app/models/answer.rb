class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  default_scope { order(best: :desc) }

  after_create :update_reputation

  after_commit :notify_users

  def set_best!
    old_best_answer = question.answers.find_by(best: true)
    return if old_best_answer == self

    old_best_answer&.update!(best: false)
    update!(best: true)
  end

  private

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end

  def notify_users
    users = question.users
    users.each do |user|
      NotifyMailer.added_answer(user, self).deliver_later
    end
  end
end
