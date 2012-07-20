class GamesController < ApplicationController
  include GamesHelper
  before_filter :signed_in_user
  before_filter :host_privileges

  ##### modifiers #####

  def update
    @game = Game.find(params[:id])

    if @game.update_attributes(params[:game])
      flash[:success] = "Game Updated"
    end
    redirect_to topic_path(@game.topic)
  end

  def edit
    @game = Game.find(params[:id])
  end

  def run
    @game = Game.find(params[:id])
    @game.topic.touch

    case @game.status
    when 'Signups Open'
      @game.update_attributes(player_cap: @game.players.count, status_id: 3)
      flash[:success] = @game.topic.title + " is now running!"
      redirect_to topic_path(@game.topic)
    when 'Pending'
      @game.update_attributes(status_id: 3)
      flash[:success] = @game.topic.title + " is now running!"
      redirect_to topic_path(@game.topic)
    else
      flash[:error] = @game.topic.title + " cannot be run."
      redirect_to topic_path(@game.topic)
    end
  end

  def finish
    @game = Game.find(params[:id])
    @game.topic.touch

    if @game.status == 'Completed'
      flash[:error] = @game.topic.title " has already completed"
      redirect_back_or root_path
    else
      @game.update_attributes(status_id: 4)
      flash[:success] = @game.topic.title + " is now over!"
      redirect_to topic_path
    end
  end
end
