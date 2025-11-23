class Goal < ApplicationRecord
  belongs_to :user

  enum status: { active: 0, achieved: 1 }

  validates :target_item, presence: true, length: { maximum: 100 }
  validates :target_amount_jpy, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :started_on, presence: true
end
