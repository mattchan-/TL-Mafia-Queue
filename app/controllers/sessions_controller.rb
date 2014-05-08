class SessionsController < ApplicationController
  before_filter :signed_in_user, except: [:new, :create]
  before_filter :admin_user, only: [:admin, :pending]

  def new
  end
  
  def create
    user = User.find(:first, :conditions => [ "lower(name) = ?", params[:session][:name].downcase ])
    if user && !user.approved?
      flash[:notice] = "Your account has not yet been approved by the administrator"
      redirect_to root_path
    elsif user && user.approved? && user.authenticate(params[:session][:password])
      if params[:remember_me]
        sign_in_permanent user
      else
        sign_in user
      end
      redirect_back_or root_path
    else
      flash.now[:error] = 'Invalid name/password combination'
      render 'new'
    end
  end

  def my_games
    @my_games = current_user.games.paginate(page: params[:my_games_page])
    @signups = current_user.signups.paginate(page: params[:signups_page])
  end

  def admin
    @users = User.paginate(page: params[:users_page])
    @games = Game.paginate(page: params[:games_page])
    store_location
  end

  def pending
    @users = User.find_all_by_approved false
    store_location
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
