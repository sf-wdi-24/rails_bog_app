class CreaturesController < ApplicationController
  before_action :set_creature, only: [:show, :edit, :update, :destroy]
  before_filter :authorize, only: [:edit, :update, :destroy]

  def index
    @creatures = Creature.all.order(created_at: :desc)
  end

  def show
  end

  def new
    if current_user
      @creature = Creature.new
    else
      redirect_to '/login'
      flash[:alert] = 'Login to create new creature'
    end
  end

  def create
    @creature = Creature.new(creature_params)
    @creature.user_id = current_user.id
    if @creature.save
      redirect_to root_path
      flash[:notice] = "New creature created"
    else
      render :new
    end
  end

  def edit
    if current_user.id != @creature.user.id
      redirect_to root_path
      flash[:alert] = 'This does not belong to you'
    else
      render :edit
    end
  end

  def update
    if @creature.update(creature_params)
      redirect_to creature_path(@creature)
      flash[:notice] = "Creature updated"
    else
      render :edit
      flash[:alert] = "Something went wrong try again"
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
    params.require(:creature).permit(:name, :description,:avatar, :user_id)
  end

end
