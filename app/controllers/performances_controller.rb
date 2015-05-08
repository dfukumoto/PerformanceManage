class PerformancesController < ApplicationController
  before_action :signed_in?
  before_action :admin_only!, only: [:unapprove, :show, :approve]

  def index
    @performances = Performance.where(user_id: current_user)
  end

  def edit
    @user = User.find_by(remember_token: User.encrypt(cookies[:remember_token]))
    @performance = Performance.find(params[:id])
  end

  def update
    @performance_form = PerformanceForm.new(edit_performance_params.merge(id: params[:id], user_id: current_user.id))
    if @performance_form.update
      flash[:success] = "稼働実績の変更に成功しました．"
      redirect_to performances_path
    else
      flash[:danger] = "稼働実績の変更に失敗しました．"
      redirect_to edit_performance_path(params[:id])
    end
  end

  def unapprove
    @performances = Performance.where(permission: false)
  end

  def show
    @performance = Performance.find(params[:id])
  end

  def approve
    @performance = Performance.find(params[:id])
    if @performance.update(permission: true, approver_id: current_user.id)
      flash[:success] = "承認しました．"
      redirect_to unapprove_performances_path
    else
      flash.now[:danger] = "承認に失敗しました．"
      redirect_to unapprove_performances_path
    end
  end

  def create
    @user = User.find_by(remember_token: User.encrypt(cookies[:remember_token]))
    @performance_form = PerformanceForm.new(performance_params.merge(user_id: current_user.id))
    if @performance_form.save
      redirect_to user_path, :flash => { :success => "稼働実績の登録に成功しました．" }
    else
      flash.now[:danger] = "稼働実績の登録に失敗しました．"
      @projects = Project.all
      render template: 'users/show'
    end
  end

  def destroy
    Performance.find(params[:id]).destroy
    flash[:success] = "稼働実績を削除しました．"
    redirect_to performances_path
  end

  private
    def performance_params
      params.require(:performance_form).permit(:start_date,
                                          :start_time,
                                          :end_date,
                                          :end_time,
                                          :content,
                                          :permission,
                                          :project_id)
    end

    def edit_performance_params
      params.require(:performance).permit(  :start_date,
                                            :start_time,
                                            :end_date,
                                            :end_time,
                                            :content,
                                            :permission,
                                            :project_id
      )
    end
end
