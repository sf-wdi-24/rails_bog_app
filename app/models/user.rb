class User < ActiveRecord::Base
  has_many :creatures
  
  validates :email, uniqueness: true
  
  has_secure_password
end
