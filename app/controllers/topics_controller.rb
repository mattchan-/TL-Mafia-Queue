class TopicsController < ApplicationController
  include GamesHelper
  WillPaginate.per_page = 20
  before_filter :signed_in_user,  except: [:show]
  before_filter :host_privileges?, only: [:new, :create]
  before_filter :admin_user, only: [:destroy]

  def new
    @topic = Topic.new
    @post = @topic.posts.build
    @game = @topic.build_game

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @topic = Topic.new(params[:topic])
    @post = @topic.posts.build(params[:post])
    @game = @topic.build_game(params[:game]) if params[:game]

    @topic.owner = @post.owner = current_user
    @game.host = current_user if params[:game]
    
    if params[:preview] || !@topic.save
      render 'new'
    else
      flash[:success] = "Topic created!"
      redirect_to topic_path(@topic)
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.paginate(page: params[:page], order: 'created_at ASC')
    @post = current_user.posts.build if signed_in?
    @game = @topic.game 
    store_location

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def reply
    @topic = Topic.find(params[:id])
    @post = current_user.posts.build(params[:post])
    @post.topic_id = @topic.id

    if params[:preview] || !@post.save
      render 'reply'
    else
      @topic.touch
      flash[:success] = "Your reply was posted!"
      redirect_to topic_path(@topic)
    end
  end

  def destroy
    Topic.find(params[:id]).destroy
    flash[:success] = "Topic destroyed."
    redirect_to admin_path
  end
end
