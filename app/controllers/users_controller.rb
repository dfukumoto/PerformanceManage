class UsersController < ApplicationController
  before_action :authentication_user!

  def show
    @user = User.find_by(remember_token: User.encrypt(cookies[:remember_token]))
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザの新規作成に成功しました．"
      binding.pry
      redirect_to user_path
    else
      render "new"
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :authority)
    end
end
