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
		@creature = Creature.new(creature_params)
		if @creature.save
			redirect_to creature_path(@creature)
			#redirect_to "/creatures/#{creature.id}"
			
		else
			#this is when error happens, render new form again to show error
			render :new
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

	def edit
		creature_id = params[:id]
		@creature = Creature.find_by_id(creature_id)
		render :edit
	end

	def update
		creature_id = params[:id]
		@creature = Creature.find_by_id(creature_id)
		creature_params = params.require(:creature).permit(:name, :description)
		@creature.update_attributes(creature_params)
		if @creature.errors.any?
			#if error happen when edit, render edit form again to show error
			render :edit
		else 
			redirect_to creature_path(@creature)
			#redirect_to "/creatures/#{creature.id}"
		end
	end

	def destroy
		creature_id = params[:id]
		creature = Creature.find_by_id(creature_id)
		#destroy creature
		creature.destroy

		redirect_to creatures_path
		#equivalent to: redirect_to "/creatures"
	end

end
