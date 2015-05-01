require 'rails_helper'

RSpec.describe "Performances", type: :request do
  before do
    @user = User.create( name: "Example User",
                        email: "user@example.com",
                     password: "foobar",
                      password_confirmation: "foobar",
                    authority: 1)

    @project = Project.create( name: "ExampleProject",
                              group: 1,
                              order: "ExampleInc",
                       project_code: "EXAMPLE",
                         start_date: "2015/05/01",
                           end_date: "2015/07/01"
    )

    @performance = Performance.new(    user_id: @user.id,
                                    start_time: "2015/05/01 10:00:00",
                                      end_time: "2015/05/01 17:00:00",
                                       content: "ExampleContent",
                                    project_id: @project.id

                                      )
  end

  subject { @performance }

  # 属性を持っているんですか．
  it { should respond_to(:start_time) }
  it { should respond_to(:end_time) }
  it { should respond_to(:content) }
  it { should respond_to(:permission) }
  it { should respond_to(:user_id) }
  it { should respond_to(:project_id) }
  it { should respond_to(:user) }
  it { should respond_to(:project) }

  it { should be_valid }

  # 稼働実績を作成した時，デフォルトで承認状況(permission)がfalseになっているんですか．
  describe "when create performance, permission is false" do
    it { should_not be_permission }
  end

  describe "when content is not present" do
    before { @performance.content = "" }
    it { should_not be_valid }
  end
  describe "when user_id is not present" do
    before { @performance.user_id = "" }
    it { should_not be_valid }
  end
  describe "when project_id is not present" do
    before { @performance.project_id = "" }
    it { should_not be_valid }
  end

  # end_timeがstart_timeよりも過去になっていたら...
  describe "when end_time than start_time in the past" do
    before do
      @performance.end_time   = @performance.start_time.ago(1800).to_s
    end
    it { should_not be_valid }
  end
  describe "when start_time same end_time" do
    before { @performance.start_time = @performance.end_time }
    it { should_not be_valid }
  end

  describe "user association" do
    it "should have the right user" do
      expect(@performance.user.name).to eq @user.name
    end
  end
  describe "project association" do
    it "should have the right project" do
      expect(@performance.project.name).to eq @project.name
    end
  end

  describe "change permission" do
    before do
      @before_permission = @performance.permission
      @performance.permission = !@before_permission
    end
    it { expect(@performance.permission).not_to eq @before_permission }
    it { expect(@performance.permission).to eq !@before_permission }
  end

end
