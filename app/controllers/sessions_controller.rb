class SessionsController < ApplicationController
  before_action :authenticationed, only: [:new, :create]
  skip_before_action :authentication_user!, only: [:new, :create]

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user_path
    else
      flash.now[:error] = 'サインインに失敗しました．'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private
    def authenticationed
      if signed_in?
        redirect_to user_path
      end
    end

end
