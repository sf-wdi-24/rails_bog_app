#
# app/controllers/creatures_controller.rb
#

class CreaturesController < ApplicationController

  # display all creatures
  def index
    # get all creatures from db and save to instance variable
    @creatures = Creature.all

    # render the index view (it has access to instance variable)
    render :index
  end

  # show the new creature form
   def new
    @creature = Creature.new
     render :new
   end


# create a new creature in the database
def create
  # whitelist params and save them to a variable
  creature_params = params.require(:creature).permit(:name, :description)

  # create a new creature from `creature_params`
  creature = Creature.new(creature_params)

  # if creature saves, redirect to route that displays all creatures
   if creature.save
     redirect_to creatures_path
      # redirect_to creatures_path is equivalent to:
      # redirect_to "/creatures"
    end
  end

end