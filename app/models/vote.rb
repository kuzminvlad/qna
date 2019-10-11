class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, inclusion: [-1, 1]
  validates :votable_id, uniqueness: { scope: %i[user_id votable_type] }
  validates :user_id, :votable_id, :votable_type, presence: true
end
