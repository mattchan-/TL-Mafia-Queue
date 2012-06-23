class StaticPagesController < ApplicationController
  def home
    @games = Game.all
  end

  def about
  end
end
