class User < ActiveRecord::Base
  extend Enumerize

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_many :performances
  has_many :project_members
  has_many :projects, through: :project_members
  has_many :partner_costs
  has_many :rank_histories

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :authority, presence: true

  enumerize :authority, in: {"管理者" => 1, "社員" => 2, "パートナー" => 3}, scope: :having_status

  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def admin?
    self.authority.value.to_i == 1 ? true : false
  end

  def staff?
    self.authority.value.to_i == 2 ? true : false
  end

  def partner?
    self.authority.value.to_i == 3 ? true : false
  end

  def assign_projects
    Project.where(id: ProjectMember.where(user_id: self))
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
