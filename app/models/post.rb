class Post < ApplicationRecord
belongs_to :user
has_one :action_plan, dependent: :destroy
has_many :comments, dependent: :destroy
has_many :likes, dependent: :destroy
has_many :liked_users, through: :likes, source: :user
end
