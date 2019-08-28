
FactoryBot.define do
  factory :micropost do
    association :user
    content { "some content" }
  end
end
