class User < ActiveRecord::Base
  has_many :creatures
  
  validates :email, uniqueness: true
  validates :password, length: { minimum: 7 }
  
  
  has_secure_password
end
