require 'rails_helper'

RSpec.describe "NewUserPages", type: :request do
  let!(:admin) { FactoryGirl.create(:admin) }

  subject{ page }

  before do
    visit signin_path
    fill_in "session_email",    with: admin.email
    fill_in "session_password", with: admin.password
    click_button "サインイン"
  end

  describe "valid information" do
    before do
      visit signup_path
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
        visit signup_path
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
        visit signup_path
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
        visit signup_path
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
        visit signup_path
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
end
