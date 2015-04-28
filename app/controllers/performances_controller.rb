class PerformancesController < ApplicationController

  def create
    @performance_form = PerformanceForm.new(performance_params)
    if @performance_form.save
      flash[:success] = "稼働実績の登録に成功しました．"
    else
      flash[:error] = "稼働実績の登録に失敗しました．"
    end
    redirect_to user_path
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
                                          :permission)
    end
end
