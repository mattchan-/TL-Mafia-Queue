class GamesController < ApplicationController
  include GamesHelper
  before_filter :signed_in_user,  except: [:show]
  before_filter :host_privileges?, only: [:new, :create]
  before_filter :is_host?, only: [:edit, :update, :run, :finish]
  before_filter :admin_user, only: [:destroy]

  def new
    @game = Game.new
    @post = @game.posts.build
  end

  def create
    @game = Game.new(params[:game])
    @post = @game.posts.build(params[:post])

    @game.host = @post.owner = current_user
    
    if params[:preview] || !@game.save
      render 'new'
    else
      flash[:success] = "Game created!"
      redirect_to game_path(@game)
    end
  end

  def show
    @game = Game.find(params[:id])
    @posts = @game.posts.paginate(page: params[:page], order: 'created_at ASC')
    @post = current_user.posts.build if signed_in?
    store_location
  end

  def update
    @game = Game.find(params[:id])

    if @game.update_attributes(params[:game])
      flash[:success] = "Game Updated"
    end
    redirect_to game_path(@game)
  end

  def edit
    @game = Game.find(params[:id])
  end

  def run
    @game = Game.find(params[:id])

    case @game.status
    when 'Signups Open'
      @game.update_attributes(player_cap: @game.approved_players.count, status_id: 3)
      flash[:success] = @game.title + " is now running!"
      redirect_to game_path(@game)
    when 'Pending'
      @game.update_attributes(status_id: 3)
      flash[:success] = @game.title + " is now running!"
      redirect_to game_path(@game)
    else
      flash[:error] = @game.title + " cannot be run."
      redirect_to game_path(@game)
    end
  end

  def finish
    @game = Game.find(params[:id])

    if @game.status == 'Completed'
      flash[:error] = @game.title " has already completed"
      redirect_back_or root_path
    else
      @game.update_attributes(status_id: 4)
      flash[:success] = @game.title + " is now over!"
      redirect_to game_path
    end
  end

  def reply
    @game = Game.find(params[:id])
    @post = current_user.posts.build(params[:post])
    @post.game_id = @game.id

    if params[:preview] || !@post.save
      render 'reply'
    else
      flash[:success] = "Your reply was posted!"
      redirect_to game_path(@game)
    end
  end

  def destroy
    Game.find(params[:id]).destroy
    flash[:success] = "Game destroyed."
    redirect_to admin_path
  end

  private

    def is_host?
      @game = Game.find(params[:id])
      redirect_back_or root_path unless current_user == @game.host
    end
end
