class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy

  belongs_to :user

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  def to_s
    self[:title]
  end
end
