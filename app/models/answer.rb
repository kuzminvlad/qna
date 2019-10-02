class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  default_scope { order(best: :desc) }

  def set_best!
    old_best_answer = question.answers.where(best: true).first
    return if old_best_answer == self
    old_best_answer.update!(best: false) unless old_best_answer.nil?
    update!(best: true)
  end

end
