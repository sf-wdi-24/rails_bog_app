class Creature < ActiveRecord::Base
  validates :name, presence: true
  validates :description, presence: true

  mount_uploader :avatar, AvatarUploader

end
