module GamesHelper
  def close_signups(game)
    game.touch
    if game.players.count >= game.player_cap
      game.update_attributes(status: 'Pending')
    end
  end
  
  def host?
    @game = Game.find(params[:id])
    @game.host == current_user || current_user.admin?
  end

  def host_privileges
    unless host?
      redirect_to game_path(@game), notice: "You do not have permission to edit " + @game.title
    end
  end

  def set_mini_status
    if @game.category == 'Newbie' || @game.player_cap > 18
      @game.update_attributes mini: false
    else
      @game.update_attributes mini: true
    end
  end
end
