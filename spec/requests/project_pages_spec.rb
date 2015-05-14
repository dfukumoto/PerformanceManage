require 'rails_helper'

RSpec.describe "ProjectPages", type: :request do
  describe "GET /project_pages" do
    let!(:user) { FactoryGirl.create(:admin) }
    before do
      ProjectGroup.create!(:name => "受託")
      ProjectGroup.create!(:name => "請負")
      visit signin_path
      fill_in "session_email",    with: user.email
      fill_in "session_password", with: user.password
      click_button "サインイン"
    end

    subject{ page }

    describe "Project create" do
      before { click_link("プロジェクト作成", href: new_project_path) }
      let!(:project) { FactoryGirl.create(:project) }
      context "valid info" do
        before do
          fill_in "project_form_name",      with: project.name
          fill_in "project_form_start_date",with: project.start_date
          fill_in "project_form_end_date",  with: project.end_date
          fill_in "project_form_order",     with: project.order
          fill_in "project_form_project_code",with: project.project_code
          select "受託",     from: "project_form_group_id"
          select user.name, from: "project_form_member_ids"
        end
        it "should create a project" do
          expect{ click_button "プロジェクト新規作成" }.to change(Project, :count).by(1)
        end
        context "correct info new project" do
          let!(:project_db) { Project.last }
          it { expect(project_db.name).to eq project.name }
          it { expect(project_db.start_date).to eq project.start_date }
          it { expect(project_db.end_date).to eq project.end_date }
          it { expect(project_db.order).to eq project.order }
        end
        context "project index" do
          before do
              click_button "プロジェクト新規作成"
              click_link("プロジェクト", href: projects_path)
          end
          let!(:project_db) { Project.last }
          it { should have_link("詳細", href: project_path(project_db)) }
          it { should have_link("編集", href: edit_project_path(project_db)) }
        end
        context "edit project" do
          before do
            click_button "プロジェクト新規作成"
            click_link("プロジェクト", href: projects_path)
          end
          context "should render project info" do
            let!(:project_db) { Project.last }
            before { click_link("編集",  href: edit_project_path(project_db)) }
            it { should have_xpath("//input[@id='project_form_name'][@value='#{project_db.name}']") }
            it { should have_xpath("//input[@id='project_form_start_date'][@value='#{project_db.start_date.strftime("%Y-%m-%d")}']") }
            it { should have_xpath("//input[@id='project_form_end_date'][@value='#{project_db.end_date.strftime("%Y-%m-%d")}']") }
            it { should have_xpath("//input[@id='project_form_order'][@value='#{project_db.order}']") }
            it { should have_xpath("//input[@id='project_form_project_code'][@value='#{project_db.project_code}']") }
            it { should have_xpath("//select[@id='project_form_member_ids']/option[@selected='selected'][text()='#{project_db.users[0].name}']") }
          end
          context "edit project" do
            context "should edit" do
              let!(:project_db) { Project.last }
              before do
                click_link("編集", href: edit_project_path(project_db))
                fill_in "project_form_name",        with: "変更できてますか"
                fill_in "project_form_start_date",  with: "2016-01-01"
                fill_in "project_form_end_date",    with: "2016-05-01"
                fill_in "project_form_order",       with: "CHANGED"
                fill_in "project_form_project_code",with: "CHANGEDCODE"
                click_button "変更"
                project_db.reload
              end
              it { expect(project_db.name).to eq "変更できてますか" }
              it { expect(project_db.start_date.strftime("%Y-%m-%d")).to eq "2016-01-01" }
              it { expect(project_db.end_date.strftime("%Y-%m-%d")).to eq "2016-05-01" }
              it { expect(project_db.order).to eq "CHANGED" }
              it { expect(project_db.project_code).to eq "CHANGEDCODE" }
            end
            context "invalid info" do
              let!(:project_db) { Project.last }
              before do
                click_link("編集", href: edit_project_path(project_db))
                fill_in "project_form_name",        with: ""
                fill_in "project_form_start_date",  with: "2016-01-01"
                fill_in "project_form_end_date",    with: "2016-05-01"
                fill_in "project_form_order",       with: ""
                fill_in "project_form_project_code",with: ""
                click_button "変更"
              end
              it { expect(current_path).to eq edit_project_path(project_db) }
            end
          end
        end
      end
      context "invalid info" do
        it { expect{ click_button "プロジェクト新規作成" }.not_to change(Project, :count) }
        context "should render danger message" do
          before { click_button "プロジェクト新規作成" }
          it { have_selector("div.alert.alert-danger", text: "プロジェクトの新規作成に失敗しました．") }
          it { should have_title("プロジェクト新規作成") }
        end
      end
    end

    describe "Project show" do
      let!(:project) { FactoryGirl.create(:project) }
      before do
        click_link("プロジェクト作成", href: new_project_path)
        fill_in "project_form_name",      with: project.name
        fill_in "project_form_start_date",with: project.start_date
        fill_in "project_form_end_date",  with: project.end_date
        fill_in "project_form_order",     with: project.order
        fill_in "project_form_project_code",with: project.project_code
        select "受託",     from: "project_form_group_id"
        select user.name, from: "project_form_member_ids"
        click_button "プロジェクト新規作成"
        click_link "プロジェクト",  href: projects_path
        click_link "詳細",        href: project_path(user.projects.first)
      end
      it { should have_content(project.name) }
      it { should have_content(project.start_date.strftime("%Y/%m/%d")) }
      it { should have_content(project.end_date.strftime("%Y/%m/%d")) }
      it { should have_content(project.order) }
      it { should have_content(project.project_code) }
      it { should have_xpath("//select[@id='member_index']/option[text()='#{user.name}']") }
    end
  end
end
