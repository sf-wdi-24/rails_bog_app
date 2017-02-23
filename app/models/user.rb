class User < ActiveRecord::Base
  has_many :creatures
  validates :name, presence: true
  validates :email, uniqueness: true, presence:true
  validates :password, length: { minimum: 7 }, presence: true

  
  has_secure_password
end
