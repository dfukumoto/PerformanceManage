class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects
  end

  def show
    @project = Project.find(params[:id])
    @project_users = project_users(@project)
  end

  def new
    @project_form = ProjectForm.new
  end

  def create
    @project = Project.new
    @project_form = ProjectForm.new(project_params)
    @project.assign_attributes(@project_form.project_attributes)
    if @project.save
      flash[:success] = "プロジェクトを新規作成しました．"
      redirect_to user_path
    else
      flash.now[:danger] = "プロジェクトの新規作成に失敗しました．"
      render 'projects/new'
    end
  end

private
  def project_params
    params.require(:project_form).permit( :name,
                                          :start_date,
                                          :end_date,
                                          :order,
                                          :project_code,
                                          :group_id)
  end

  def project_users(project)
    users = []
    project.users.each do |user|
      users << [user.name, user.id]
    end
    users
end
