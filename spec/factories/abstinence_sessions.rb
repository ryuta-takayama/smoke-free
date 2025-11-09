FactoryBot.define do
  factory :abstinence_session do
    association :user
    started_at { Time.zone.now - 1.day }
    ended_at { nil }
  end
end
