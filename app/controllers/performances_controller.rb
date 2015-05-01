class PerformancesController < ApplicationController
  before_action :signed_in?
  before_action :admin_only!, only: [:unapprove, :show, :approve]


  def unapprove
    @performances = Performance.where(permission: false)
  end

  def show
    @performance = Performance.find(params[:id])
  end

  def approve
    @performance = Performance.find(params[:id])
    if @performance.update(permission: true)
      flash[:success] = "承認しました．"
      redirect_to unapprove_performances_path
    else
      flash.now[:error] = "承認に失敗しました．"
      redirect_to unapprove_performances_path
    end
  end

  def create
    @user = User.find_by(remember_token: User.encrypt(cookies[:remember_token]))
    @performance_form = PerformanceForm.new(performance_params.merge(user_id: current_user.id))
    if @performance_form.save
      redirect_to user_path, notice: "稼働実績の登録に成功しました．"
    else
      flash.now[:error] = "稼働実績の登録に失敗しました．"
      @projects = Project.all
      render template: 'users/show'
    end
  end

  def destroy

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
end
