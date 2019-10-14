class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  default_scope { order(best: :desc) }

  def set_best!
    old_best_answer = question.answers.find_by(best: true)
    return if old_best_answer == self

    old_best_answer&.update!(best: false)
    update!(best: true)
  end
end
