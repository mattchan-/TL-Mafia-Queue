class SessionsController < ApplicationController
  WillPaginate.per_page = 1 # remove when done testing

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

  def my_games
    @my_topics = current_user.topics.paginate(page: params[:my_topics_page])
    @signups = []
    current_user.signups.each { |game| @signups << game.topic }
    @signups = @signups.paginate(page: params[:signups_page])
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
