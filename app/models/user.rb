class User < ActiveRecord::Base
  extend Enumerize

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_many :performances
  has_many :project_members
  has_many :projects, through: :project_members
  has_many :partner_costs
  has_many :rank_histories

  accepts_nested_attributes_for :projects

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :authority, presence: true

  enumerize :authority, in: {:admin => 1, :staff => 2, :partner => 3}, scope: true #:having_status

  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def admin?
    self.authority.admin?
  end

  def staff?
    self.authority.staff?
  end

  def partner?
    self.authority.partner?
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
