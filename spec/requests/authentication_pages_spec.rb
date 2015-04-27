require 'rails_helper'

RSpec.describe "AuthenticationPages", type: :request do
  describe "GET /authentication_pages" do
    subject{ page }

    describe "signin page" do
      before { visit signin_path }

      it { should have_content("サインイン") }
      it { should have_title("サインイン") }
    end
  end
end
