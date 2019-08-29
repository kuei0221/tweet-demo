FactoryBot.define do
  factory :user do
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

  end

end
