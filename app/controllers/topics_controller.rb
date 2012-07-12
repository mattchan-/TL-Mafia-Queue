class TopicsController < ApplicationController
  include GamesHelper
  WillPaginate.per_page = 20
  before_filter :signed_in_user,  except: [:show]

  def new
    @topic = Topic.new
    @post = @topic.posts.build
    @game = @topic.build_game

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @topic = current_user.topics.build(params[:topic])
    @post = current_user.posts.build(params[:post])
    @game = current_user.hosted_games.build(params[:game])

    if params[:preview] || !@topic.save
      render 'new'
    else
      @post.topic = @topic
      @post.save
      if !@game.player_cap.nil?
        set_mini_status
        @game.topic = @topic
        @game.save
      end
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
end
