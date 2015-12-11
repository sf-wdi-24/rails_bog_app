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
