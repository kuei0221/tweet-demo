require "faker"

def random_content(words_range = (5..10))
  Faker::Lorem.sentence(word_count: Random::rand(words_range))
end

50.times do |n|
  #set 100 user , while first user is admin
  if n == 0
    @user = User.create!(
      name: "adminstrator", 
      email: "testing@example.com", 
      password: "password", 
      password_confirmation: "password",
      admin: true,
      activated: true,
      activated_at: Time.zone.now
      )
  else
    @user = User.create!(
      name: Faker::Name.name, 
      email: Faker::Internet.unique.email,
      password: "password",
      password_confirmation: "password",
      activated: true,
      activated_at: Time.zone.now
    )
  end
  #attach avatar with random img from unsplash 
  # avatar_image =  URI.open(Unsplash::Photo.random.urls.small)
  avatar_image =  URI.open(Faker::Avatar.image)

  @user.avatar.attach(io: avatar_image, filename: "avatar-user#{@user.id}", content_type: "image/jpg")
  #create random numeber of post for each user
  rand(5..30).times { @user.posts.create(content: random_content(5..40)) }
end

#sharing random number of post for each user
User.all.each do |user|
  @posts = Post.random(rand(1..30))
  @posts.each {|post| user.share! post, random_content(5..40) }
end
#commenting random number of post for each user
User.all.each do |user|
  @posts = Post.random(rand(1..50))
  @posts.each { |post| user.comment! post, random_content(5..40) }
end
#liking random number of post for each user
User.all.each do |user|
  @posts = Micropost.random(rand(1..100))
  @posts.each { |post| user.like post }
end

#following random number of user for each user
User.all.each do |user|
  @users = User.random(rand(1..50))
  @users.each {|other_user| user.follow other_user }
end
