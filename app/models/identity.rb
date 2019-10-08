class Identity < ApplicationRecord
  belongs_to :user

  validates_presence_of :provider, :uid
  validates_uniqueness_of :uid, scope: :provider

  scope :provider, -> (provider){ where(provider: provider) }
  
  def self.create_user_with_identity(res, provider)
    password = SecureRandom.base64(8)
    user = User.new(
      name: res[:name],
      email: res[:email],
      activated: true,
      password: password,
      password_confirmation: password
    )
    if user.save
      avatar_image = URI.open(res[:image_url])
      user.avatar.attach(io: avatar_image, filename: "avatar-user#{user.id}", content_type: "image/jpg")
      create(user: user, uid: res[:uid], provider: provider)
      return user
    else
      raise "Errors occur when creating user with identity: #{user.errors.full_messages}"
      return false
    end
  end

end
