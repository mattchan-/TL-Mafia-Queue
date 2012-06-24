class SessionsController < ApplicationController

  def new
  end
  
  def create
    user = User.find(:first, :conditions => [ "lower(name) = ?", params[:session][:name].downcase])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid name/password combination'
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
