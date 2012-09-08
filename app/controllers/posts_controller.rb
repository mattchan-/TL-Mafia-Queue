class PostsController < ApplicationController
  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.content = params[:post][:content]
    if params[:preview] || !@post.save
      render 'edit'
    else
      flash[:success] = "Post updated!"
      redirect_to topic_path(@post.topic)
    end
  end

  def quote
    @quoted_post = Post.find(params[:id])
    @topic = @quoted_post.topic
    @post = @topic.posts.build(params[:post])
  end
end
