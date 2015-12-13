class Creature < ActiveRecord::Base
	validates :name, presence: true, format: {with: /\A\w+\s?\w+\Z/, message: ": Only letter, number and/or underscore allowed."}
	validates :description, presence: true
end
