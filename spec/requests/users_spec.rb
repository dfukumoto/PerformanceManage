require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    @user = User.new( name: "Example User",
                      email: "user@example.com",
                      password: "foobar",
                      password_confirmation: "foobar",
                      authority: 1)
  end
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:admin?) }
  it { should respond_to(:staff?) }
  it { should respond_to(:partner?) }


  it { should be_valid }


  describe "when name is not presence" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  describe "when email is not presence" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  describe "when password is not presence" do
    before do
      @user.password = " "
      @user.password_confirmation = " "
    end
    it { should_not be_valid }
  end
  describe "when password doesnt match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end


  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_same = @user.dup
      user_same.email = @user.email.upcase
      user_same.save
    end
    it { should_not be_valid }
  end

  describe "Check Authrority" do
    describe "admin?" do
      before do
        @user.authority = 1
      end
      it { should be_admin }
    end
    describe "staff?" do
      before do
        @user.authority = 2
      end
      it { should be_staff }
    end
    describe "partner?" do
      before do
        @user.authority = 3
      end
      it { should be_partner }
    end
  end
end
