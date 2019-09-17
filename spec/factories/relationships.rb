FactoryBot.define do
  factory :relationship do
    association :user
    follower_id { Random.rand(1..1000) }
    followed_id { Random.rand(1..1000) }
  end
end
