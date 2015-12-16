class Creature < ActiveRecord::Base
  belongs_to :user
  
  validates :name, presence: true, length: {maximum: 100}
  validates :description, presence: true, length: {maximum: 2000 }

  mount_uploader :avatar, AvatarUploader

end
