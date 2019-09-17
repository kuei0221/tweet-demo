FactoryBot.define do
  factory :user, aliases: [:follower, :following] do
    id { Random.rand(1..10000) }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password {"password"}
    password_confirmation {"password"}
    admin { false }
    activated {true}
    activated_at {Time.zone.now}

    trait :inactivated do
      activated {false}
    end

    trait :admin do
      admin {true}
    end

    factory :user_with_posts do

      transient do
        posts_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:post, evaluator.posts_count, user: user)
      end

    end

  end

end
