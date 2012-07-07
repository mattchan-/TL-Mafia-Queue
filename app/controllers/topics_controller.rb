class TopicsController < ApplicationController
  before_filter :signed_in_user,  except: [:show]

  def new
    @topic = Topic.new
    @post = @topic.posts.build

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def create
    @topic = current_user.topics.build(params[:topic])
    @post = current_user.posts.build(params[:post])

    if @topic.save
      @post.topic_id = @topic.id
      @post.save
      flash[:success] = "Topic created!"
      redirect_to topic_path(@topic)
    else
      render 'new'
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @posts = @topic.posts.all
    @post = current_user.posts.build if signed_in?

    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
