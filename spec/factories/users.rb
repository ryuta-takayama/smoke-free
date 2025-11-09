FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    nickname { Gimei.name.kanji }
    age { Faker::Number.between(from: 20, to: 80) }
    reason_to_quit { :health }
    password { "Password1" }
    password_confirmation { password }

    transient do
      with_settings { true }
    end

    after(:create) do |user, evaluator|
      if evaluator.with_settings
        setting = create(:smoking_setting, user: user)
        create(:abstinence_session, user: user, started_at: setting.quit_start_datetime)
      end
    end

    trait :with_smoking_setting do
      with_settings { true }
    end

    trait :without_smoking_setting do
      with_settings { false }
    end
  end
end
