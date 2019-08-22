class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true, 
                   length: { minimum: 6, maximum: 51}

                   validates :email, presence: true,
                   length: {maximum: 255},
                   uniqueness: {case_sensitive: false},
                   format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
                   
  has_secure_password
  validates :password, presence: true,
                       length: {minimum: 8, maximum: 51}
  
  
  private
  def downcase_email
    self.email = email.downcase
  end


end
