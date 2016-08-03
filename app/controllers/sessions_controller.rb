class SessionsController < ApplicationController

  before_action :already_signed_in, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_credentials(session_params[:user_name], session_params[:password])
    login!(@user)
  end

  def destroy
    logout!
  end

  def session_params
    params.require(:user).permit(:user_name, :password)
  end
end
