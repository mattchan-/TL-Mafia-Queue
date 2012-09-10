class PostsController < ApplicationController
  before_filter :signed_in_user

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
      redirect_to game_path(@post.game)
    end
  end

  def quote
    @quoted_post = Post.find(params[:id])
    @game = @quoted_post.game
    @post = @game.posts.build(params[:post])
  end
end
