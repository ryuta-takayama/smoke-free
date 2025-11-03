class SmokingSetting < ApplicationRecord
  belongs_to :user, inverse_of: :smoking_setting

  # Virtual attribute to accept a date-only input from the form
  attr_accessor :quit_start_date

  # Basic validations aligned with NOT NULL constraints
  validates :daily_cigarette_count, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :cigarette_price_jpy, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :cigarette_per_pack, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :quit_start_datetime, presence: true

  before_validation :apply_defaults_and_convert_date

  private

  def apply_defaults_and_convert_date
    # Default 20 if not provided
    self.cigarette_per_pack ||= 20

    return if quit_start_datetime.present?

    if quit_start_date.present?
      # Convert YYYY-MM-DD to the beginning of day in app time zone
      date = begin
        Date.parse(quit_start_date.to_s)
      rescue ArgumentError, TypeError
        nil
      end

      self.quit_start_datetime = date&.in_time_zone&.beginning_of_day
    end
  end
end
