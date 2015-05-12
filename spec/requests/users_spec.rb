require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) {
    User.create( name: "Example User",
                      email: "user@example.com",
                      password: "foobar",
                      password_confirmation: "foobar",
                      authority: 1)
  }
  let!(:performance) {
    Performance.create( user_id:  user.id,
                                    start_time: "2015/05/01 10:00:00",
                                      end_time: "2015/05/01 17:00:00",
                                       content: "ExampleContent",
                                    project_id: 1)
  }
  let!(:project) {
    Project.create( name: "ExampleProject",
                           group_id: 1,
                              order: "ExampleInc",
                       project_code: "EXAMPLE",
                         start_date: "2015/05/01",
                           end_date: "2015/07/01")
  }
  let!(:project_member) {
    ProjectMember.create( user_id: user.id,
                        project_id: project.id)
  }

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authority) }
  it { should respond_to(:admin?) }
  it { should respond_to(:staff?) }
  it { should respond_to(:partner?) }
  it { should respond_to(:performances) }
  it { should respond_to(:projects) }
  it { should respond_to(:project_members) }
  it { should respond_to(:partner_costs) }
  it { should respond_to(:rank_histories) }


  it { should be_valid }


  describe "when name is not presence" do
    before { user.name = " " }
    it { should_not be_valid }
  end
  describe "when email is not presence" do
    before {  user.email = " " }
    it { should_not be_valid }
  end
  describe "when authority is not presence" do
    before {  user.authority = " "}
    it { should_not be_valid }
  end
  describe "when password is not presence" do
    before do
       user.password = " "
       user.password_confirmation = " "
    end
    it { should_not be_valid }
  end
  describe "when password doesnt match confirmation" do
    before {  user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end


  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user foo,com user_at_foo.org example.user foo.
                     foo bar_baz.com foo bar+baz.com]
      addresses.each do |invalid_address|
         user.email = invalid_address
        expect( user).not_to be_valid
      end
    end
  end
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
         user.email = valid_address
        expect( user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      @user_same =  user.dup
      @user_same.email =  user.email.upcase
      @user_same.save
    end
    it { expect(@user_same).not_to be_valid }
  end

  describe "Check Authrority" do
    describe "admin?" do
      before do
         user.authority = "管理者"
      end
      it { should be_admin }
    end
    describe "staff?" do
      before do
         user.authority = "社員"
      end
      it { should be_staff }
    end
    describe "partner?" do
      before do
         user.authority = "パートナー"
      end
      it { should be_partner }
    end
  end

  describe "take the performance of user" do
    it { expect( user.performances.first.content).to eq  performance.content }
  end

  describe "take the project of user" do
    it { expect( user.projects.first.name ).to eq project.name }
  end
end
