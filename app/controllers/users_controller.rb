class UsersController < ApplicationController
  before_action :authentication_user!
  before_action :admin_only!, only: [:new, :create]

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
      redirect_to user_path
    else
      render "new"
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :authority)
    end

    def admin_only!
      unless current_user.admin?
        flash[:error] = "管理者のみアクセスできます．"
        redirect_to user_path
      end
    end
end
