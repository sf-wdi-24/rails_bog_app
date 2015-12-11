class CreaturesController < ApplicationController
	#display all creatures
	def index
		@creatures = Creature.all
		render :index
	end

	#show the new creature form
	def new
		@creature = Creature.new
		render :new
	end

	#create a new creature in the database
	def create
		#whitelist params and save them to variable
		creature_params = params.require(:creature).permit(:name, :description)
		#create a new creature from creature_params
		creature = Creature.new(creature_params)
		if creature.save
			redirect_to creature_path(creature)
			# redirect_to creatures_path
			# creatures_path is equivalent to "/creatures"
		end
	end	

	def show
		#get creature id from the url params
		creature_id = params[:id]

		#use creature_id to find the creature in the database
		#and save it to an instance variable
		@creature = Creature.find_by_id(creature_id)
		render :show
	end

end
