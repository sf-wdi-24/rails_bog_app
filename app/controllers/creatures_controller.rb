class CreaturesController < ApplicationController

#display all creatures
	def index
		#get all creatures from db and save to instance variable
		@creatures = Creature.all

		# render the index view - it has to access to the instnace variable
		render :index
	end
	#show new creature HTML form
	def new
		@creature = Creature.new
		render :new
	end
	#adding a CREATE route
	def create
		# hm this line is defining the params?
		creature_params = params.require(:creature).permit(:name, :description, :image)
		# new creature
		creature = Creature.new(creature_params)
		# if creature saves, redirect to route that displays all creatures

		if creature.save
			redirect_to creatures_path(creature)
			#redirect to creature path is the same as redirect to /creatures
		end

	end
	def show
		# get the creature id from the url params
		creature_id = params[:id]
		#find by creature ID
		@creature = Creature.find_by_id(creature_id)
		# render the show view
		render :show
	end
	def edit
		#get creature id
		creature_id = params[:id]
		#use creature id to find the creature in the database
		@creature = Creature.find_by_id(creature_id)

		#render the edit view
		render :edit
	end
	def update
		#get creature by ID
		creature_id = params[:id]

		#use creature id to find
		creature = Creature.find_by_id(creature_id)

		#save params to a variable
		creature_params = params.require(:creature).permit(:name, :description, :image)

		#update the creature
		creature.update_attributes(creature_params)

		#redirect
		redirect_to creature_path(creature)
	end
	def destroy
		#get creature id
		creature_id = params[:id]
		#use creature id to find creature in db
		creature = Creature.find_by_id(creature_id)
		#destroy the creature
		creature.destroy
		#redirect to creatures index
		redirect_to creatures_path
	end

end
