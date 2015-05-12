class ProjectForm
  include ActiveModel::Model

  attr_accessor :name, :start_date, :end_date, :order, :project_code, :group_id, :member_ids

  def project_attributes
    {}.tap do |hash|
      hash.store(:name,       @name)
      hash.store(:start_date, @start_date)
      hash.store(:end_date,   @end_date)
      hash.store(:order,      @order)
      hash.store(:project_code,@project_code)
      hash.store(:group_id,   @group_id)
    end
  end

  def assign_project_attributes(project)
    tap do |instance|
      instance.name         = project.name
      instance.start_date   = project.start_date.strftime("%Y/%m/%d")
      instance.end_date     = project.end_date.strftime("%Y/%m/%d")
      instance.order        = project.order
      instance.project_code = project.project_code
      instance.group_id     = project.group_id
      instance.member_ids   = generate_assigned_members(project)
    end
  end

  # params[:project_form][:member_ids]から空を削除した配列を返す．
  def shape_user_ids
    @member_ids.reject(&:empty?)
  end

  def project_member_create(project)
    if shape_user_ids.length == 0
      false
    else
      @member_ids.each do |user_id|
        ProjectMember.create(:project_id => project.id, :user_id => user_id.to_i)
      end
      true
    end
  end

  def generate_assigned_members(project)
    [].tap do |array|
      project.users.each do |member|
        array.push(member.id)
      end
    end
  end
end
