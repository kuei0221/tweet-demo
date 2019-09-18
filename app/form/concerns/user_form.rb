module UserForm

  extend ActiveSupport::Concern

  included do

    attr_accessor :user, :name, :email, :password, :password_confirmation, :avatar
    validates :name, presence: true, 
                     length: { minimum: 6, maximum: 51}

    validates :email, presence: true,
                      length: {maximum: 255},
                      format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }  
  end

  class_methods do
    # allow to rails default setting to find user path rather than formo object path
    def model_name
      ActiveModel::Name.new(User)
    end
  end

  def initialize(params=nil, user=nil)
    super params
    @params = params
    #if no user given, assume creating new. Otherwise assumes updating
    user.nil? ? @user = User.unscoped.new(params) : @user = user
  end
  
  #gather all errors to form object itself
  def promote_errors(child_object)
    child_object.errors.map{ |error, msg| self.errors.add(error, msg) }
  end

end