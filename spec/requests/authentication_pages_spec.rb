require 'rails_helper'

RSpec.describe "AuthenticationPages", type: :request do
  describe "GET /authentication_pages" do
    subject{ page }

    describe "incorrect access" do
      describe "visit user-info-page" do
        before { visit user_path}
        it { should have_content("サインイン") }
      end
      describe "visit create-user-page" do
        before { visit new_user_path }
        it { should have_content("サインイン") }
      end
      describe "visit unapprove-performances-index-page" do
        before { visit unapprove_performances_path }
        it { should have_content("サインイン") }
      end
    end

    describe "signin page" do
      before { visit signin_path }

      it { should have_content("サインイン") }
      it { should have_title("サインイン") }
    end

    describe "signin" do
      before { visit signin_path }
      describe "with invalid informatio" do
        before { click_button "サインイン" }

        it { should have_title("サインイン") }
      end
      describe "with admin information" do
        let!(:user) {  FactoryGirl.create(:admin) }
        before do
          fill_in "session_email",    with: user.email
          fill_in "session_password", with: user.password
          click_button "サインイン"
        end
        after(:all) { User.delete_all }
        it { should have_content(user.name) }
        it { should have_content(user.email) }
        it { should have_content("管理者") }
        it { should have_link("ユーザ新規作成", href: new_user_path)}
        it { should have_link("未承認稼働実績一覧", href: unapprove_performances_path) }
        it { should have_link("サインアウト", href: signout_path) }
      end
      describe "with staff information" do
        let!(:user) {  FactoryGirl.create(:staff) }
        before do
          fill_in "session_email",    with: user.email
          fill_in "session_password", with: user.password
          click_button "サインイン"
        end
        it { should have_content(user.name) }
        it { should have_content(user.email) }
        it { should have_content("社員") }
        it { should have_link("サインアウト", href: signout_path) }
      end
      describe "with partner information" do
        let!(:user) {  FactoryGirl.create(:partner) }
        before do
          fill_in "session_email",    with: user.email
          fill_in "session_password", with: user.password
          click_button "サインイン"
        end
        it { should have_content(user.name) }
        it { should have_content(user.email) }
        it { should have_content("パートナー") }
        it { should_not have_link("プロジェクト", href: "#") }
        it { should have_link("サインアウト", href: signout_path) }
      end

    end
  end
end
