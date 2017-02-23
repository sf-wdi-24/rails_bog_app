class CreaturesController < ApplicationController

	# show homepage
	def index
		@creatures = Creature.all
	end

	# show new creature form
	def new
		@creature = Creature.new
	end

	# create new creature
	def create
		creature_params = params.require(:creature).permit(:name, :description)

		creature = Creature.new(creature_params)
		creature.errors[:name] 

		if creature.save
			redirect_to creature_path(creature)
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
