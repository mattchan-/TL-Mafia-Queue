class StaticPagesController < ApplicationController
  WillPaginate.per_page = 20

  helper_method :sort_column, :sort_direction

  def home
    @games = Game.order(sort_column + " " + sort_direction).paginate(page: params[:page])
    store_location
  end

  private
    def sort_column
      %w[status_id updated_at].include?(params[:sort]) ? params[:sort] : "updated_at"
    end

    def sort_direction
      %w[ASC DESC].include?(params[:direction]) ? params[:direction] : "DESC"
    end
end
