class CreaturesController < ApplicationController

	

	#display all creatures
	def index
		#get all creatures from dbdb and save to instance variable
		@creatures = Creature.all
        render :index
	end

	def new
		@creature = Creature.new
		render :new
	end

	def create
		creature_params = params.require(:creature).permit(:name, :description)
		creature = Creature.new(creature_params)

		if creature.save
			redirect_to creature_path(creature)
		    #equivalent to redirect_to "/creatures/#{creature."
		end
	end

	def show
		creature_id = params[:id]
		@creature = Creature.find_by_id(creature_id)
		render :show
	end

	def edit
		creature_id = params[:id]
		@creature = Creature.find_by_id(creature_id)
		render :edit
	end

	def update
		creature_id = params[:id] 
		creature = Creature.find_by_id(creature_id)
		creature_params = params.require(:creature).permit(:name, :description)
		creature.update_attributes(creature_params)
		redirect_to creature_path(creature)
	end

	def destroy
		creature_id = params[:id]
		creature = Creature.find_by_id(creature_id)
		creature.destroy
		redirect_to creatures_path
	end
		

end
