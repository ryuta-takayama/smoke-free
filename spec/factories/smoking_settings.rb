FactoryBot.define do
  factory :smoking_setting do
    association :user
    daily_cigarette_count { 10 }
    cigarette_price_jpy { 600 }
    cigarette_per_pack { 20 }
    quit_start_datetime { Time.zone.now.beginning_of_day }
  end
end
