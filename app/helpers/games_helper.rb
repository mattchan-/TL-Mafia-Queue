module GamesHelper
  def close_signups(game)
    game.touch
    if game.players.count >= game.maximum_players
      game.update_attributes(status_id: 2) # status 2 means game pending
    end
  end
  
  def host?
    @game = Game.find(params[:id])
    @game.host == current_user
  end

  def host_privileges
    unless host?
      redirect_to game_path(@game), notice: "You do not have permission to edit " + @game.title
    end
  end
end
