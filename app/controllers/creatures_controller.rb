class CreaturesController < ApplicationController
	#display all creatures
	def index
		#get all creatures from dbdb and save to instance variable
		@creatures = Creature.all

		render :index
	end

end
