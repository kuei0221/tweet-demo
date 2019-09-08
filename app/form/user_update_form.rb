class UserUpdateForm
  
  include ActiveModel::Model
  include UserForm
  validate :empty_password_with_confirmation

  def update
    if self.valid? && user.update(@params)
      return true
    else
      promote_errors(user)
      return false
    end
  end

  private

  def empty_password_with_confirmation
    if password.empty? && password_confirmation.present?
      errors.add(:base, "Should not leave confirmation without password")
    end
  end

end