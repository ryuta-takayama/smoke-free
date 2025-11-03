class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_one :smoking_setting, dependent: :destroy, inverse_of: :user
  has_many :abstinence_sessions, dependent: :destroy
  has_one :goal, -> { where(status: 0) }, class_name: "Goal"
  has_many :restart_challenges, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :action_plans, dependent: :destroy
  accepts_nested_attributes_for :smoking_setting
  enum reason_to_quit: { health: 0, money: 1, family: 2, work: 3, other: 4 }

  after_create :create_abstinence_start_data



  before_validation :normalize_fields

  validates :nickname, 
   presence: true,
   length: {minimum: 2, maximum: 30},
   format: {with: /\A(?!\s*\z).+\z/, message: "ニックネームは空白のみにはできません"}


  validates :email,
    presence: true,
    uniqueness: {case_sensitive: false},
    format: {with: URI::MailTo::EMAIL_REGEXP, message: "有効なメールアドレスを入力してください"}

  validates :password,
    presence: true,
    length: {minimum: 6},
    format: {with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).+\z/, message: "パスワードは英字と数字の両方を含めてください"},
    if: :password_required?

  validates :age,
   presence: true,
   numericality: { only_integer: true, greater_than_or_equal_to: 20, message: "は20以上である必要があります" }


 


  private

  def normalize_fields
     self.email = email.to_s.strip.downcase
     self.nickname = nickname.to_s.strip
  end

  def password_required?
  !persisted? || password.present? || password_confirmation.present?
  end

  def create_abstinence_start_data
  return unless smoking_setting.present?

  abstinence_sessions.create!(
    started_at: smoking_setting.quit_start_datetime
  )
  end

end
