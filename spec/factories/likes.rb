FactoryBot.define do
  factory :like do
    association :micropost
    association :user
    micropost_id { Random.rand(1..1000) }
    user_id { Random.rand(1..1000) }
  end
end
