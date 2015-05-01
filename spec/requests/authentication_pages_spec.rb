require 'rails_helper'

RSpec.describe "AuthenticationPages", type: :request do
  describe "GET /authentication_pages" do
    subject{ page }

    describe "incorrect access" do
      before { visit user_path }
      it { should have_content("サインイン") }
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
        let(:user) do
          User.create( name:   "ExampleUser",
                    email:  "example@example.com",
                    password: "foobar",
                    password_confirmation: "foobar",
                    authority: 1)
        end
        before do
          fill_in "session_email",    with: user.email
          fill_in "session_password", with: user.password
          click_button "サインイン"
        end
        after(:all) { User.delete_all }
        it { should have_content(user.name) }
        it { should have_content(user.email) }
        it { should have_content("管理者") }
        it { should have_link("サインアウト", href: signout_path) }
      end
      describe "with staff information" do
        let(:user) do
          User.create( name:   "ExampleUser",
                    email:  "example@example.com",
                    password: "foobar",
                    password_confirmation: "foobar",
                    authority: 2)
        end
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
        let(:user) do
          User.create( name:   "ExampleUser",
                    email:  "example@example.com",
                    password: "foobar",
                    password_confirmation: "foobar",
                    authority: 3)
        end
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
