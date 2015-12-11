class CreaturesController < ApplicationController
	def index
		@creatures = Creature.all
		render :index
	end
end
