class VotesController < ApplicationController
  include GamesHelper
  before_filter :signed_in_user
  before_filter :is_host?, only: [:approve]

  def create
    @vote = Vote.new
    @vote.game_id = params[:game_id]
    @vote.user_id = params[:user_id]
    @vote.save

    flash[:success] = "Your signup for " + @vote.game.title + " has been submitted"
    redirect_back_or root_path
  end

  def approve
    @vote = Vote.find(params[:id])
    @vote.toggle!(:approved)
    
    @game = @vote.game
    @game.touch

    respond_to do |format|
      format.js {} # show.js.erb
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    flash[:success] = "You are no longer signed up for " + @vote.game.title

    @vote.game.touch
    @vote.destroy

    redirect_back_or root_path
  end

  private

    def is_host?
      redirect_to root_path, notice: "You do not have permission to submit this request" unless Vote.find(params[:id]).game.host == current_user
    end
end
