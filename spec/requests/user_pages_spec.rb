require 'rails_helper'

RSpec.describe "NewUserPages", type: :request do
  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:staff) { FactoryGirl.create(:staff) }

  subject{ page }

  before do
    visit signin_path
    fill_in "session_email",    with: admin.email
    fill_in "session_password", with: admin.password
    click_button "サインイン"
  end

  describe "valid information" do
    before do
      visit new_user_path
      fill_in "user_name",    with: Faker::Name.name
      fill_in "user_email",   with: Faker::Internet.email
      fill_in "user_password",              with: "foobar"
      fill_in "user_password_confirmation", with: "foobar"
    end
    it "should create a user" do
      expect{ click_button "新規作成" }.to change(User, :count).by(1)
    end
    it "should render success message" do
      click_button "新規作成"
      expect(page).to have_selector("div.alert.alert-success", text: "ユーザの新規作成に成功しました")
    end
  end

  describe "invalid information" do
    describe "same user information" do
      before do
        visit new_user_path
        fill_in "user_name",    with: "Example"
        fill_in "user_email",   with: admin.email
        fill_in "user_password",              with: "foobar"
        fill_in "user_password_confirmation", with: "foobar"
      end
      it "shouldnt create a user" do
        expect{ click_button "新規作成" }.not_to change(User, :count)
      end
      it "should render error message" do
        click_button "新規作成"
        expect(page).to have_selector("div.alert.alert-danger", text: "ユーザの新規作成に失敗しました")
      end
    end

    describe "blank user_name" do
      before do
        visit new_user_path
        fill_in "user_email",   with: Faker::Internet.email
        fill_in "user_password",              with: "foobar"
        fill_in "user_password_confirmation", with: "foobar"
      end
      it "shouldnt create a user" do
        expect{ click_button "新規作成" }.not_to change(User, :count)
      end
      it "should render error message" do
        click_button "新規作成"
        expect(page).to have_selector("div.alert.alert-danger", text: "ユーザの新規作成に失敗しました")
      end
    end

    describe "blank user_email" do
      before do
        visit new_user_path
        fill_in "user_name",   with: Faker::Name.name
        fill_in "user_password",              with: "foobar"
        fill_in "user_password_confirmation", with: "foobar"
      end
      it "shouldnt create a user" do
        expect{ click_button "新規作成" }.not_to change(User, :count)
      end
      it "should render error message" do
        click_button "新規作成"
        expect(page).to have_selector("div.alert.alert-danger", text: "ユーザの新規作成に失敗しました")
      end
    end

    describe "blank password" do
      before do
        visit new_user_path
        fill_in "user_name",   with: Faker::Name.name
        fill_in "user_email",  with: Faker::Internet.email
      end
      describe "both blank" do
        it "shouldnt create a user" do
          expect{ click_button "新規作成" }.not_to change(User, :count)
        end
        it "should render error message" do
          click_button "新規作成"
          expect(page).to have_selector("div.alert.alert-danger", text: "ユーザの新規作成に失敗しました")
        end
      end
      describe "one blank" do
        before do
          fill_in "user_password",  with: "foobar"
        end
        it "shouldnt create a user" do
          expect{ click_button "新規作成" }.not_to change(User, :count)
        end
        it "should render error message" do
          click_button "新規作成"
          expect(page).to have_selector("div.alert.alert-danger", text: "ユーザの新規作成に失敗しました")
        end
      end
    end
  end

  describe "user index" do
    before { click_link "ユーザ一覧", href: users_path }
    it { should have_selector("table", text: admin.name) }
    it { should have_selector("table", text: staff.name) }
    it { should have_link("変更", href: edit_user_path(admin)) }
    it { should have_link("変更", href: edit_user_path(staff)) }
  end

  describe "edit user" do
    before {
      click_link "ユーザ一覧", href: users_path
      click_link "変更", href: edit_user_path(staff)
    }
    context "invalid info" do
      before do
        fill_in "user_name",  with: ""
        fill_in "user_email", with: ""
        click_button "変更"
      end
      it { should have_selector("div.alert.alert-danger", text: "ユーザ情報の変更に失敗しました．") }
      it { should have_title("ユーザ編集") }
    end
    context "valid info" do
      before do
        fill_in "user_name",  with: "ChangedName"
        fill_in "user_email", with: "change@change.com"
        select "パートナー",   from: "user_authority"
        click_button "変更"
        staff.reload
      end
      it { should have_selector("div.alert.alert-success",  text: "ユーザ情報の変更に成功しました．") }
      it { expect(current_path).to eq users_path }
      it { expect(staff.name).to eq "ChangedName" }
      it { expect(staff.email).to eq "change@change.com" }
      it { expect(staff.authority).to eq :partner }
    end
  end
end
