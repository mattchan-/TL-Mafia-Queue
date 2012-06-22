class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user, only: [:show]

  def show
    @user = User.find(params[:id])
    @games = @user.games
  end

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the TL Mafia Queue!"
      redirect_to @user
    else
      render 'new'
    end
  end
end