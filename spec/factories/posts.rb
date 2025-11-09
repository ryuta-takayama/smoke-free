FactoryBot.define do
  factory :post do
    association :user
    sequence(:body) { |n| "テスト投稿#{n}" }
  end
end
