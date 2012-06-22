class VotesController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]

  def create
    @vote = Vote.new
    @vote.user_id = params[:user_id]
    @vote.game_id = params[:game_id]
    @vote.save

    @vote.game.signups += 1
    @vote.game.save

    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: 'You have joined ' + @vote.game.title }
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    @vote.game.signups -= 1
    @vote.game.save
    @vote.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user) }
    end
  end
end
