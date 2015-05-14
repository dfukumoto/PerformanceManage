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
      instance.start_date   = project.start_date
      instance.end_date     = project.end_date
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

  def generate_assigned_members(project)
    [].tap do |array|
      project.users.each do |member|
        array.push(member.id)
      end
    end
  end

  # プロジェクトとユーザを紐付けるためにparamsのmember_idsを参照して，
  # そのユーザオブジェクトを配列にして返す．
  def users_attributes(project= nil)
    project.users.delete_all unless project.nil?
    shape_user_ids.map do |user|
      [].tap do |array|
        array << User.find(user.to_i)
      end
    end
  end

=begin
  def users_attributes
    shape_user_ids.map.with_index do |member_id, index|
      {}.tap do |hash|
        hash.store(index.to_s, {id: member_id.to_i})
      end
    end
  end
=end
end
