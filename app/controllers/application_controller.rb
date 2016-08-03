class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user



  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def login!(user)
    @user = user
    if @user.nil?
      flash.now[:errors] ||= []
      flash.now[:errors] << "User name is invalid or password is wrong"
      render :new
    else
      @user.reset_session_token!
      session[:session_token] = @user.session_token
      redirect_to cats_url
    end
  end

  def logout!
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
    redirect_to cats_url
  end

  def already_signed_in
    if current_user
      flash[:errors] ||= []
      flash[:errors] << "You are already logged in"
      redirect_to cats_url
    end
  end

  
end
