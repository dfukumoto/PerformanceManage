require 'rails_helper'

RSpec.describe "AuthenticationPages", type: :request do
  describe "GET /authentication_pages" do
    subject{ page }

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
        it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      end
    end
  end
end
