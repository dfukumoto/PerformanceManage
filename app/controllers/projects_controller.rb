class ProjectsController < ApplicationController
  before_action :project_find, only: [ :show, :edit, :update ]
  before_action :assign_users, only: [ :new, :edit, :update ]

  def index
    @projects = current_user.projects
  end

  def show
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
      @project_form.project_member_create(@project)
      flash[:success] = "プロジェクトを新規作成しました．"
      redirect_to user_path
    else
      flash.now[:danger] = "プロジェクトの新規作成に失敗しました．"
      @users = assign_users
      render 'projects/new'
    end
  end

  def edit
    @project_form = ProjectForm.new.assign_project_attributes(@project)
  end

  def update
    @project_form = ProjectForm.new(project_params)
    @project.assign_attributes(@project_form.project_attributes)
    if @project.save
      # TODO: ProjectMemberテーブルを更新する処理を書く．
      flash[:success] = "プロジェクト情報を変更しました．"
      redirect_to projects_path
    else
      flash.now[:danger] = "プロジェクト情報の変更に失敗しました．"
      render action: 'edit'
    end
  end

private
  def project_params
    params.require(:project_form).permit( :name,
                                          :start_date,
                                          :end_date,
                                          :order,
                                          :project_code,
                                          :group_id,
                                          member_ids: [])
  end

  # 引数のプロジェクトに属するユーザの配列を生成する．
  def project_users(project)
    users = []
    project.users.each do |user|
      users << [user.name, user.id]
    end
    users
  end

  # プロジェクト新規作成・編集に使うユーザの配列を生成する．
  def assign_users
    users = User.all.order(:id)
    @users = [].tap do |array|
      users.each do |user|
        array.push([user.name, user.id])
      end
    end
  end

  def project_find
    @project = Project.find(params[:id])
  end
end
