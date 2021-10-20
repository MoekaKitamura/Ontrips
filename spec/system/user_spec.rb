require 'rails_helper'

RSpec.describe User, type: :system do
  let!(:region) { Place.create(name_jp: "東アジア", name_en: "East Asia") }
  let!(:country) { region.children.create(code: "JP", name_jp: "日本", name_en: "Japan") }
  let!(:city) { country.children.create(code: "JP", name_jp: "福岡", name_en: "Fukuoka") }

  describe 'アクセス制限のテスト' do
    context 'ユーザーがログインせず旅行掲示板一覧ページにアクセスした場合' do
      it 'ログイン画面に遷移' do
        visit trips_path
        expect(page).to have_content 'ログイン'
      end
    end
  end

  describe 'ログイン機能のテスト' do
    before do
      user = FactoryBot.create(:user)
      profile = user.build_profile(id: user.id, place_id: city.id)
      profile.save!
      visit new_user_session_path
      fill_in :user_email, with: 'general@ex.com'
      fill_in :user_password, with: 'password'
      click_button "ログイン"
    end
    context 'ユーザーがログインした場合' do
      it 'プロフィール画面が見れるようになる' do
        expect(page).to have_content 'General User'
        expect(page).to have_content 'ログインしました'
      end
    end
    context 'ログイン後、アカウント編集ページにアクセスした場合' do
      it '自分のアカウント編集ページが見れる' do
        visit edit_user_registration_path
        expect(page).to have_content 'Edit Your Account'
        expect(page).to have_field 'user_email', with: 'general@ex.com'
      end
    end
    context 'ログイン後、旅行掲示板一覧ページにアクセスした場合' do
      it '旅行掲示板一覧が見れる' do
        visit trips_path
        expect(page).to have_content 'Find Trips'
      end
    end
    context 'ログアウトした場合' do
      it 'ログイン画面へ遷移' do
        click_on "Account"
        click_on "Log out"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ログアウトしました'
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe '管理画面のテスト' do
    before do
      user = FactoryBot.create(:second_user)
      profile = user.build_profile(id: user.id, place_id: city.id)
      profile.save!
      visit new_user_session_path
      fill_in :user_email, with: 'admin@ex.com'
      fill_in :user_password, with: 'password'
      click_button "ログイン"
    end
    context '管理ユーザーがrails_adminへアクセスした場合' do
      it '管理画面にアクセスできる' do
        visit rails_admin_path
        expect(page).to have_content 'サイト管理'
      end
    end
  end
end