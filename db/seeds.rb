# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "faker"

User.create(name: "adminstrator", 
            email: "testing@example.com", 
            password: "password", 
            password_confirmation: "password",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)

99.times do |n|
  @user = User.create(name: Faker::Name.name, 
              email: Faker::Internet.unique.email,
              password: "password",
              password_confirmation: "password",
              activated: true,
              activated_at: Time.zone.now
  )
end

User.all.each do |user|
  user.avatar.attach(io: File.open(Rails.root.join("app","assets","images","sample-avatar.jpg")), 
                     filename: "sample-avatar.jpg", 
                     content_type: "image/jpg")
end

users = User.take(10)

50.times do |n|
  users.each { |user| user.posts.create!(content: Faker::Lorem.sentence(word_count:5))}
end

posts = Post.take(100)

posts.each do |post|
  users.each do |user| 
    user.comments.create!(content: Faker::Lorem.sentence(word_count: 5), post_id: post.id)
    user.like(post)
  end
end

comments = Comment.take(100)
comments.each do |comment|
  users.each {|user| user.like comment }
end

users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each {|followed| user.follow(followed)}
followers.each {|follower| follower.follow(user)}