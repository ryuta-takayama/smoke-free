class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  MAX_BODY_LENGTH = 300

  before_validation :normalize_body

  validates :body,
    presence: { message: "を入力してください" },
    length: { maximum: MAX_BODY_LENGTH, message: "は#{MAX_BODY_LENGTH}文字以内で入力してください" },
    format: { with: /\A(?!\s*\z).+\z/, message: "は空白のみでは投稿できません" }

  private

  def normalize_body
    return if body.nil?
    # 前後空白除去
    self.body = body.strip
  end
end
