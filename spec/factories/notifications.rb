FactoryBot.define do
  factory :notification do
    user { nil }
    post { nil }
    action { "MyString" }
    feeder { nil }
  end
end
