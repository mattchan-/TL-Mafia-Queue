class GamesController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :edit, :update, :run, :destroy]

 def new
   @game = Game.new
   #game.host_id = current_user.id
 end

  def create
    params[:game][:signups] = 0
    params[:game][:running] = false
    
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
      format.html # index.html.erb
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

  def run
    @game = Game.find(params[:id])
    if @game.running
      @game.update_attributes(running: false)
      flash[:success] = @game.title + " is now paused."
    else
      @game.update_attributes(running: true)
      flash[:success] = @game.title + " is now running!"
    end
    redirect_to current_user
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
