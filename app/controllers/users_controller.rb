class UsersController < ApplicationController
  before_action :authentication_user!

  def show
    @user = User.find_by(remember_token: User.encrypt(cookies[:remember_token]))
  end

  private
    def method_name

    end
end
