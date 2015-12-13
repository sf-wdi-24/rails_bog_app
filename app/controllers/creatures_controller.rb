class CreaturesController < ApplicationController
  before_action :set_creature, only: [:show, :edit, :update, :destroy]

  def index
    @creatures = Creature.all
  end

  def show
  end

  def new
    @creature = Creature.new
  end

  def create
    @creature = Creature.new(creature_params)
    if @creature.save
      redirect_to root_path
      flash[:notice] = "New creature created"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @creature.update(creature_params)
      redirect_to creature_path(@creature)
      flash[:notice] = "Creature updated"
    else
      render :edit
    end
  end

  def destroy
    @creature.destroy
    redirect_to root_path
    flash[:alert] = "Creature successfully destroyed"
  end

private
  def set_creature
    @creature = Creature.find(params[:id])
  end

  def creature_params
    params.require(:creature).permit(:name, :description,:avatar)
  end

end
