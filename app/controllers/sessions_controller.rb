class SessionsController < ApplicationController
  WillPaginate.per_page = 20 # remove when done testing

  def new
  end
  
  def create
    user = User.find(:first, :conditions => [ "lower(name) = ?", params[:session][:name].downcase ])
    if user && user.authenticate(params[:session][:password])
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
