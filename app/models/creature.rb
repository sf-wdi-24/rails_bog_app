class Creature < ActiveRecord::Base
	has_attached_file :image, styles: {medium: "600X600>", thumb: "150x150#"}
	validates :name, presence: true, format: {with: /\A[\w ]*[^\W_][\w ]*\Z/, message: ": Only letter, number and/or underscore allowed."}
	validates :description, presence: true
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
