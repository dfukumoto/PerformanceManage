require 'rails_helper'

RSpec.describe "PerformancePages", type: :request do
  def projectmember_valid_attributes(user, project)
    {
      :project_id => project.id.to_i,
      :user_id => user.id.to_i
    }
  end

  subject { page }

  let!(:user) { FactoryGirl.create(:staff) }
  let!(:project) { FactoryGirl.create(:project) }
  before do
    ProjectMember.create! projectmember_valid_attributes(user, project)
    visit signin_path
    fill_in "session_email",    with: user.email
    fill_in "session_password", with: user.password
    click_button "サインイン"
  end

  describe "valid information" do
    before do
      select project.name,    from: "performance_form_project_id"
      select "2015/05/06",    from: "performance_form_start_date"
      select "10:00",         from: "performance_form_start_time"
      select "2015/05/06",    from: "performance_form_end_date"
      select "17:00",         from: "performance_form_end_time"
      fill_in "performance_form_content",      with: "ExamplePerformance"
    end

    it "should create a performance" do
      expect{ click_button "稼働登録" }.to change(Performance, :count).by(1)
    end
    it "should render successs message" do
      click_button "稼働登録"
      expect(page).to have_selector("div.alert.alert-success", text: "稼働実績の登録に成功しました")
    end
  end

  describe "invalid information" do
    describe "leave content" do
      before do
        select project.name,  from: "performance_form_project_id"
        select "2015/05/06",  from: "performance_form_start_date"
        select "10:00",       from: "performance_form_start_time"
        select "2015/05/06",  from: "performance_form_end_date"
        select "17:00",       from: "performance_form_end_time"
      end
      it "shouldnt create a performance" do
        expect{ click_button "稼働登録" }.not_to change(Performance, :count)
      end
      it "should render error message" do
        click_button "稼働登録"
        expect(page).to have_selector("div.alert.alert-danger", text: "稼働実績の登録に失敗しました")
      end
    end
    describe "same start_datetime and end_datetime" do
      before do
        select project.name,  from: "performance_form_project_id"
        select "2015/05/06",  from: "performance_form_start_date"
        select "10:00",       from: "performance_form_start_time"
        select "2015/05/06",  from: "performance_form_end_date"
        select "10:00",       from: "performance_form_end_time"
        fill_in "performance_form_content", with: "ExamplePerformance"
        click_button "稼働登録"
      end
      it "shouldnt create a performance" do
        expect{ click_button "稼働登録" }.not_to change(Performance, :count)
      end
      it "should render error message" do
        click_button "稼働登録"
        expect(page).to have_selector("div.alert.alert-danger", text: "稼働実績の登録に失敗しました")
      end
    end
    describe "when end_time than start_time in the past" do
      before do
        select project.name,  from: "performance_form_project_id"
        select "2015/05/06",  from: "performance_form_start_date"
        select "15:00",       from: "performance_form_start_time"
        select "2015/05/06",  from: "performance_form_end_date"
        select "10:00",       from: "performance_form_end_time"
        fill_in "performance_form_content", with: "ExamplePerformance"
      end
      it "shouldnt create a performance" do
        expect{ click_button "稼働登録" }.not_to change(Performance, :count)
      end
      it "should render error message" do
        click_button "稼働登録"
        expect(page).to have_selector("div.alert.alert-danger", text: "稼働実績の登録に失敗しました")
      end
    end
  end

  describe "when access my performances index page" do
    let!(:other_user) { FactoryGirl.create(:partner) }
    let!(:user_performance)        { user.performances.first }
    let!(:other_user_performance)  { other_user.performances.first }
    before { visit performances_path }

    describe "should render my performances" do
      it "with info_button of performance" do
        expect(page).to have_link("詳細", href: performance_path(user_performance))
      end
      it "with change_button of performance" do
        expect(page).to have_link("変更", href: edit_performance_path(user_performance))
      end
      it "with delete_button of performance" do
        expect(page).to have_link("削除", href: performance_path(user_performance))
      end
      it "shouldnt render other_users performances" do
        expect(page).not_to have_link("詳細", href: performance_path(other_user_performance))
      end
    end

    describe "should render my performance info view" do
      before { visit performance_path(user_performance) }

      it { should have_content(user_performance.user.name) }
      it { should have_content(user_performance.project.name) }
      it { should have_content(user_performance.start_time) }
      it { should have_content(user_performance.end_time) }
      it { should have_content(user_performance.content) }
      it { should_not have_link("承認", approve_performance_path(user_performance)) }

      describe "incorrect access to other user performances" do
        before { visit performance_path(other_user_performance) }
        it { should have_selector("div.alert.alert-danger", "管理者以外は他ユーザの稼働実績は見れません") }
      end
    end
    
    describe "should render my performance change view" do
      before { visit edit_performance_path(user_performance) }

      it { should have_content(user_performance.content) }
      it { should have_selector("input.btn.btn-primary", "稼働登録") }

      describe "incorrect access to other user performance change view" do
        before { visit edit_performance_path(other_user_performance) }
        it { should have_selector("div.alert.alert-danger", "稼働実績作成者以外は変更できません．") }
      end
    end
  end
end
