class GamesController < ApplicationController
  include GamesHelper
  before_filter :signed_in_user,  except: [:show]
  before_filter :host_privileges, only: [:edit, :update, :run, :finish, :destroy]

  ##### constructor #####

 def new
   @game = Game.new
 end

  def create
    @game = current_user.games.build(params[:game])

    if @game.save
      flash[:success] = "Game Created"
      redirect_to current_user
    else
      render 'new'
    end
  end

  ##### display #####

  def show
    @game = Game.find(params[:id])
    @posts = @game.posts.paginate(page: params[:page], order: 'created_at ASC')
    @post = current_user.posts.build if signed_in?
    store_location

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  ##### modifiers #####

  def update
    @game = Game.find(params[:id])
    if @game.update_attributes(params[:game])
      flash[:success] = "Game Updated"
      redirect_to game_path(@game)
    else
      render 'edit'
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def reply
    @game = Game.find(params[:id])
    @post = current_user.posts.build(params[:post])
    @post.game_id = @game.id
    @game.touch
    
    if @post.save
      flash[:success] = "Reply Successful"
      redirect_to game_path(@game)
    end
  end

  def quote
    @game = Game.find(params[:game_id])
    @post = current_user.posts.build(params[:post])
    @quoted_post = Post.find(params[:post_id])
    @post.game_id = @game.id
    @game.touch

    if @post.save
      flash[:success] = "Reply Successful"
      redirect_to game_path(@game)
    end
  end

  def run
    @game = Game.find(params[:id])
    case @game.status_id
    when 1
      @game.update_attributes(maximum_players: @game.players.count, status_id: 3)
      flash[:success] = @game.title + " is now running!"
      redirect_to game_path
    when 2
      @game.update_attributes(status_id: 3)
      flash[:success] = @game.title + " is now running!"
      redirect_to game_path
    when 3
      flash[:error] = @game.title + " is already running"
      redirect_to game_path(@game)
    when 4
      flash[:error] = @game.title + " has already completed"
      redirect_to game_path(@game)
    end
  end

  def finish
    @game = Game.find(params[:id])
    if @game.status_id == 4
      flash[:error] = @game.title " has already completed"
      redirect_back_or(root_path)
    else
      @game.update_attributes(status_id: 4)
      flash[:success] = @game.title + " is now over!"
      redirect_to game_path
    end
  end

  ##### destructor #####

  def destroy
    @game = Game.find(params[:id])

    @game.votes.each do |vote|
      vote.destroy
    end

    @game.destroy

    redirect_to current_user
  end
end
