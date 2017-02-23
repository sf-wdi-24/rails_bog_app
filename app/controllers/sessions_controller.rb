class SessionsController < ApplicationController
  def new
    if current_user
      redirect_to root_path
      flash[:alert] = 'GTFO, already logged in'
    end
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id 
      redirect_to root_path
      flash[:notice] = 'Logged in'
    else
      redirect_to '/login'
      flash[:alert] = 'Something went wrong, enter correct shit'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
    flash[:notice] = 'Logged out'
  end
end

