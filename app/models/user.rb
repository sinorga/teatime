class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :email, :full_name, :password_confirmation
  validates_uniqueness_of :email
end