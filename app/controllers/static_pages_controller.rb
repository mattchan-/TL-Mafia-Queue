class StaticPagesController < ApplicationController
  def home
    @game = current_user.games.build if signed_in?
  end

  def about
  end
end
