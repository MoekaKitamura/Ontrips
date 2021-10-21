require 'rails_helper'

RSpec.describe User, type: :system do
  let!(:region) { Place.create(name_jp: "東アジア", name_en: "East Asia") }
  let!(:country) { region.children.create(code: "JP", name_jp: "日本", name_en: "Japan") }
  let!(:city) { country.children.create(code: "JP", name_jp: "福岡", name_en: "Fukuoka") }

  describe 'アクセス制限・サインアップのテスト' do
    context 'ログインせず旅行一覧ページにアクセスした場合' do
      it 'ログイン画面に遷移' do
        visit trips_path
        expect(page).to have_content 'ログイン'
      end
    end
    context 'ログインせずユーザー一覧ページにアクセスした場合' do
      it 'ログイン画面に遷移' do
        visit profiles_path
        expect(page).to have_content 'ログイン'
      end
    end
    context 'ログインせずブログ一覧ページにアクセスした場合' do
      it 'ログイン画面に遷移' do
        visit blogs_path
        expect(page).to have_content 'ログイン'
      end
    end
    context 'ログインせずトップページにアクセスした場合' do
      it 'トップページにアクセスできる' do
        visit tops_index_path
        expect(current_path).to eq tops_index_path
        expect(page).to have_content '新しい旅の形 〜あなたの旅に"交流"を〜'
      end
    end
    context 'ユーザー新規登録をした場合' do
      it '確認メールが送信され、確認画面が表示される' do
        visit new_user_registration_path
        fill_in 'user_name', with: 'General User'
        fill_in 'user_email', with: 'general@ex.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        expect { click_on 'アカウント登録' }.to change { ActionMailer::Base.deliveries.size }.by(1)
        expect(current_path).to eq confirm_email_path
        expect(page).to have_content 'Welcome to Ontrips!!'
      end
    end
    context '新規登録後の確認メールのリンクをクリックした場合' do
      it 'ログインできて、マイページにアクセスできる' do
        visit new_user_registration_path
        fill_in 'user_name', with: 'General User'
        fill_in 'user_email', with: 'general@ex.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_on 'アカウント登録'
        user = User.last
        token = user.confirmation_token
        profile = user.build_profile(id: user.id, place_id: city.id)
        profile.save
        visit user_confirmation_path(confirmation_token: token)
        expect(page).to have_content 'General User'
        expect(page).to have_content 'メールアドレスが確認できました。'
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
        visit root_path
        click_on "Account"
        click_on "Log out"
        sleep 1.0
        page.driver.browser.switch_to.alert.accept
        expect(current_path).to eq root_path
        expect(page).to have_content 'ログアウトしました'
        expect(page).to have_content 'Log in'
      end
    end
  end

  describe '管理画面・アカウント削除のテスト' do
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
    context 'アカウントを削除した場合' do
      it 'ログイン画面へ遷移' do
        visit edit_user_registration_path
        click_on 'アカウント削除'
        sleep 1.0
        page.driver.browser.switch_to.alert.accept
        expect(current_path).to eq root_path
        expect(page).to have_content 'アカウントを削除しました。またのご利用をお待ちしております。'
        expect(page).to have_content 'Log in'
      end
    end
  end
end