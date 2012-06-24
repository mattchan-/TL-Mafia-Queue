class GamesController < ApplicationController
  before_filter :signed_in_user,  only: [:new, :create, :edit, :update, :change_status, :destroy]
  before_filter :is_owner?,   only: [:edit, :update, :change_status, :destroy]

 def new
   @game = Game.new
   #game.host_id = current_user.id
 end

  def create
    params[:game][:signups] = 0
    params[:game][:status_id] = 1
    
    @game = current_user.games.build(params[:game])

    if @game.save
      flash[:success] = "Game Created"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def index
    @games = Game.all

    respond_to do |format|
      format.html { redirect_to root_path }
    end
  end

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      flash[:success] = "Game Updated"
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def change_status
    @game = Game.find(params[:id])
    new_status = params[:status_id].to_i
    if new_status > 4
      flash[:error] = 'Invalid status'
      redirect_back_or(root_path)
    else
      @game.update_attributes(status_id: params[:status_id])
      if new_status == 1
        flash[:success] = @game.title + " is now open for signups."
      elsif new_status == 2
        flash[:success] = @game.title + " is now running!"
      elsif new_status == 3
        flash[:success] = @game.title + " is paused."
      else
        flash[:success] = @game.title + " has completed."
      end
      redirect_to game_path
    end
  end

  def destroy
    @game = Game.find(params[:id])

    @game.votes.each do |vote|
      vote.destroy
    end
    @game.destroy

    respond_to do |format|
      format.html { redirect_to current_user }
    end
  end
end
