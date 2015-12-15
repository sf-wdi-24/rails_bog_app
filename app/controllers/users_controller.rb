class UsersController < ApplicationController
  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to root_path
      flash[:notice] = "Thanks for signing up"
    else
      redirect_to "/signup"
    end
  end

private
  def user_params
    params.requre(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
