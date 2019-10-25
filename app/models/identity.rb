class Identity < ApplicationRecord
  belongs_to :user

  validates_presence_of :provider, :uid
  validates_uniqueness_of :uid, scope: :provider

  scope :provider, -> (provider){ where(provider: provider) }
  #should i constraint type of provider in db levels
  
  def self.create_user_with_identity(res, provider)
    # In theroy, response and provider should already be checked by logger
    # data in response valid of not will be filter by User model (user.save will be false)
    
    user = new_user_with_response(res)
    if user.save
      avatar_image = open_image_url_else_default_avatar(res)
      user.avatar.attach(io: avatar_image, filename: "avatar-user#{user.id}", content_type: "image/jpg")
      identity = create(user: user, uid: res[:uid], provider: provider)
      return user if identity.valid?
      puts "Errors occur when creating identity: #{identity.errors.full_messages}"
      nil
    else
      puts "Errors occur when creating user with identity: #{user.errors.full_messages}"
      nil
    end
  end

  private
  def self.new_user_with_response(response)
    password = SecureRandom.base64(8)
    user = User.new(
      name: response[:name],
      email: response[:email],
      activated: true,
      password: password,
      password_confirmation: password
    )
  end

  def self.open_image_url_else_default_avatar(response)
    begin
      URI.open(response[:image_url])
    rescue Errno::ENOENT => e
      puts e.message + ", loading default avatar instead"
      File.open(Rails.root.join("app","assets","images","sample-avatar.jpg"))
    end
  end
end
