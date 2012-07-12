class VotesController < ApplicationController
  include GamesHelper
  before_filter :signed_in_user, only: [:create, :destroy]

  def create
    @vote = Vote.new
    @vote.game_id = params[:game_id]
    @vote.user_id = params[:user_id]
    @vote.save

    @vote.game.touch
    @vote.game.topic.touch
    close_signups(@vote.game)
    redirect_back_or root_path
  end

  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    @vote.game.touch
    @vote.game.topic.touch
    redirect_back_or root_path
  end
end
