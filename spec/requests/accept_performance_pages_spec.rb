require 'rails_helper'

RSpec.describe "AcceptPerformancePages", type: :request do
  subject{ page }

  let!(:admin) { FactoryGirl.create(:admin) }

  before do
    visit signin_path
    fill_in "session_email",    with: admin.email
    fill_in "session_password", with: admin.password
    click_button "サインイン"
    visit unapprove_performances_path
  end

  describe "unapprove performances" do
    let(:performance) { admin.performances.first }
    it { should have_link("詳細", href: performance_path(performance)) }
    it { should have_link("承認", href: approve_performance_path(performance)) }

    describe "accept performance" do
      before { click_link "承認" }
      it { should have_selector("div.alert.alert-success", text: "承認しました") }
      it { should_not have_link("詳細", href: performance_path(performance)) }
      it { should_not have_link("承認", href: approve_performance_path(performance)) }
      it "change permission" do
        expect(performance.reload.permission).to eq true
      end
    end

    describe "render unapprove performance infomation" do
      before { click_link("詳細", href: performance_path(performance)) }
      it { should have_title("稼働実績詳細") }
      it { should have_content(performance.user.name) }
      it { should have_content(performance.project.name) }
      it { should have_content(performance.start_time.to_s) }
      it { should have_content(performance.end_time.to_s) }
      it { should have_content(performance.content) }

      describe "accept performance" do
        before { click_link "承認" }
        it { should have_selector("div.alert.alert-success", text: "承認しました") }
        it { should_not have_link("詳細", href: performance_path(performance)) }
        it { should_not have_link("承認", href: approve_performance_path(performance)) }
        it "change permission" do
          expect(performance.reload.permission).to eq true
        end
      end
    end
  end
end
