module GamesHelper  
  def host?
    @game = Game.find(params[:id])
    @game.host == current_user || current_user.admin?
  end

  def host_privileges
    unless host?
      redirect_to game_path(@game), notice: "You do not have permission to edit " + @game.title
    end
  end
end
