class UserRegisterForm
  include ActiveModel::Model
  include UserForm

  def set_default_avatar
    if avatar.blank?
      user.avatar.attach(io: File.open(Rails.root.join("app","assets","images","sample-avatar.jpg")), 
                       filename: "sample-avatar.jpg", 
                       content_type: "image/jpg")
    end
  end

  def save
    if self.valid? && user.valid?
      user.save
    else
      #since if first condition fails, validation in model level won't run, so no possible error
      promote_errors(user) if user.invalid? 
      return false
    end
  end

end
