class UsersController < ApplicationController
  before_filter :signed_in_user,  except: [:new, :create]
  before_filter :correct_user,    only: [:edit, :update]
  before_filter :admin_user,      only: [:approve_account, :toggle_host_privileges, :destroy]

  helper_method :sort_column, :sort_direction

  ##### constructor #####

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Your account has been created and will be activated as soon as it is approved by the administrator."
      redirect_to root_path
    else
      render 'new'
    end
  end

  ##### modifiers #####

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to mygames_path
    else
      render 'edit'
    end
  end

  def approve_account
    @user = User.find(params[:id])
    @user.toggle!(:approved)
    redirect_back_or admin_path
  end

  def toggle_host_privileges
    @user = User.find(params[:id])
    if !@user.admin?
      @user.toggle!(:host_privileges)
    end
    redirect_back_or admin_path
  end

  ##### destructor #####

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to admin_path
  end

  ##### helpers #####

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path, notice: "You do not have permission to view this page" unless current_user? @user
    end

    def sort_column
      %w[status_id updated_at].include?(params[:sort]) ? params[:sort] : "updated_at"
    end

    def sort_direction
      %w[ASC DESC].include?(params[:direction]) ? params[:direction] : "DESC"
    end
end