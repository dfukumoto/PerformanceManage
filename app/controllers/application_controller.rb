class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  helper_method :signed_in?, :sign_out, :current_user=, :current_user, :authentication_user!, :admin_only!

  before_action :authentication_user!

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  private
    def signed_in?
      !current_user.nil?
    end

    def sign_out
      self.current_user = nil
      cookies.delete(:remember_token)
    end

    def current_user=(user)
      @current_user = user
    end

    def current_user
      remember_token = User.encrypt(cookies[:remember_token])
      @current_user ||= User.find_by(remember_token: remember_token)
    end

    def authentication_user!
      unless signed_in?
        redirect_to signin_path
      end
    end

    def admin_only!
      unless current_user.admin?
        flash[:danger] = "管理者のみアクセスできます．"
        redirect_to user_path
      end
    end
end
