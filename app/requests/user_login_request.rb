class UserLoginRequest
  include ActiveModel::Model

  attr_accessor :email, :password, :remember_me
  validates_presence_of :email, :password
end
