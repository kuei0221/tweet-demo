FactoryBot.define do
  factory :notification do
    association :user
    association :micropost
    action { "MyString" }
    feeder { nil }
    new {true}

    trait :read do
      new {false}
    end
  end
end
