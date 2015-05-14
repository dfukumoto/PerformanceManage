class PerformancesController < ApplicationController
  before_action :signed_in?
  before_action :admin_only!, only: [:unapprove, :approve]
  before_action :not_allow_change!, only: [:edit, :update, :destroy]
  before_action :person_limit!, only: [:edit, :destroy]


  def index
    @performances = Performance.where(user_id: current_user).order(created_at: :desc)
  end

  def edit
    @performance = Performance.find(params[:id])
    @performance_form = PerformanceForm.new.assign_performance_attributs(@performance)
  end

  def update
    @performance_form = PerformanceForm.new(performance_params.merge(user_id: current_user.id))
    @performance = Performance.find(params[:id])
    @performance.assign_attributes(@performance_form.performance_attributes)
    if @performance.save
      flash[:success] = "稼働実績の変更に成功しました．"
      redirect_to performances_path
    else
      flash[:danger] = "稼働実績の変更に失敗しました．"
      redirect_to edit_performance_path(params[:id])
    end
  end

  def unapprove
    @performances = Performance.where(permission: false).order(created_at: :desc)
  end

  def show
    @performance = Performance.find(params[:id])
    unless @performance.user == current_user || current_user.admin?
      flash[:danger] = "管理者以外は他ユーザの稼働実績は見れません．"
      redirect_to performances_path
    end
  end

  def approve
    if Performance.find(params[:id]).update(permission: true, approver_id: current_user.id)
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
      params.require(:performance_form).permit(:start_time,
                                          :end_time,
                                          :content,
                                          :permission,
                                          :project_id)
    end

    def not_allow_change!
      @performance = Performance.find(params[:id])
      if @performance.permission?
        flash[:danger] = "承認済みのため，変更が許可されていません．"
        redirect_to performances_path
      end
    end

    def person_limit!
      unless Performance.find(params[:id]).user == current_user
        flash[:danger] = "稼働実績作成者以外は変更できません"
        redirect_to performances_path
      end
    end
end
