class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments

  default_scope { order(best: :desc) }

  def set_best!
    old_best_answer = question.answers.where(best: true).first
    return if old_best_answer == self
    old_best_answer.update!(best: false) unless old_best_answer.nil?
    update!(best: true)
  end

end
