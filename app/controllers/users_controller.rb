class UsersController < ApplicationController
  before_action :authentication_user!
  before_action :admin_only!, only: [:new, :create]

  def show
    @user = User.find_by(remember_token: User.encrypt(cookies[:remember_token]))
    @performance_form = PerformanceForm.new
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
      flash.now[:error] = "ユーザの新規作成に失敗しました．"
      render "new"
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :authority)
    end


end
