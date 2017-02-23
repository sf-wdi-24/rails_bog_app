class Creature < ActiveRecord::Base
	validates :name, presence: true, length: {minimum: 2}
	validates :description, presence: true, length: {minimum: 2}
end
