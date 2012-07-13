class GamesController < ApplicationController
  include GamesHelper
  before_filter :signed_in_user,  except: [:show]
  before_filter :host_privileges, only: [:edit, :update, :run, :finish, :destroy]

  ##### constructor #####

  def new
    @game = Game.new
  end

  def create
    @game = current_user.hosted_games.build(params[:game])

    if @game.save
      set_mini_status
      flash[:success] = "Game Created"
      redirect_to current_user
    else
      render 'new'
    end
  end

  ##### display #####

  def show
    @game = Game.find(params[:id])
    store_location

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  ##### modifiers #####

  def update
    @game = Game.find(params[:id])

    if @game.update_attributes(params[:game])
      set_mini_status
      flash[:success] = "Game Updated"
      redirect_to topic_path(@game.topic)
    else
      render 'edit'
    end
  end

  def edit
    @game = Game.find(params[:id])
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
    case @game.status
    when 'Signups Open'
      @game.update_attributes(player_cap: @game.players.count, status: 'Running')
      flash[:success] = @game.topic.title + " is now running!"
      redirect_to topic_path(@game.topic)
    when 'Pending'
      @game.update_attributes(status: 'Running')
      flash[:success] = @game.topic.title + " is now running!"
      redirect_to topic_path(@game.topic)
    else
      flash[:error] = @game.topic.title + " cannot be run."
      redirect_to topic_path(@game.topic)
    end
  end

  def finish
    @game = Game.find(params[:id])
    if @game.status == 'Completed'
      flash[:error] = @game.topic.title " has already completed"
      redirect_back_or root_path
    else
      @game.update_attributes(status: 'Completed')
      flash[:success] = @game.topic.title + " is now over!"
      redirect_to topic_path
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
