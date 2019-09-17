FactoryBot.define do
  factory :micropost do
    association :user
    id { Random.rand(1..10000) }
    content { Faker::Lorem.sentence(word_count: 5) }

    factory :post, class: Post do

      factory :post_with_comments do
        transient do
          comments_count {10}
        end

        after(:create) do |post, evaluator|
          create_list(:comment, evaluator.comments_count, post: post)
        end
      end

      
    end

    factory :comment, class: Comment do
      association :post
    end

    factory :micropost_with_likes do
      transient do
        likes_count {10}
      end

      after(:create) do |micropost, evaluator|
        create_list(:like, evaluator.likes_count, micropost: micropost, user: :user)
      end
    end
  end
end
