class UsersController < ApplicationController
  before_filter :signed_in_user,  only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,    only: [:show, :edit, :update]
  before_filter :admin_user,      only: [:destroy]

  helper_method :sort_column, :sort_direction

  ##### constructor #####

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

  ##### display #####

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  ##### modifiers #####

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      if !current_user.admin?
        sign_in @user
      end
      redirect_to @user
    else
      render 'edit'
    end
  end

  ##### destructor #####

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  ##### helpers #####

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path, notice: "You do not have permission to view this page" unless current_user?(@user) || current_user.admin?
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def sort_column
      %w[status_id updated_at].include?(params[:sort]) ? params[:sort] : "updated_at"
    end

    def sort_direction
      %w[ASC DESC].include?(params[:direction]) ? params[:direction] : "DESC"
    end
end