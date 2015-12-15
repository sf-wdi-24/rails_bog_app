class Creature < ActiveRecord::Base
  belongs_to :user
  
  validates :name, presence: true
  validates :description, presence: true

  mount_uploader :avatar, AvatarUploader

end
