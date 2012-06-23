module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path, notice: "You do not have permission to view this page" unless current_user?(@user)
  end

  def is_owner?
    @game = Game.find(params[:id])
    redirect_to root_path, notice: "You are not the host of this game" unless @game.host == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end
end
