require 'rails_helper'

RSpec.describe Talk, type: :system do
  let!(:region) { Place.create(name_jp: "東アジア", name_en: "East Asia") }
  let!(:country) { region.children.create(code: "JP", name_jp: "日本", name_en: "Japan") }
  let!(:city) { country.children.create(code: "JP", name_jp: "福岡", name_en: "Fukuoka") }

  describe 'ダイレクトメッセージ機能' do
    before do
      user1 = FactoryBot.create(:user)
      profile = user1.build_profile(id: user1.id, place_id: city.id)
      profile.save!
      @user2 = FactoryBot.create(:second_user)
      profile = @user2.build_profile(id: @user2.id, place_id: city.id)
      profile.save!
      visit new_user_session_path
      fill_in :user_email, with: 'general@ex.com'
      fill_in :user_password, with: 'password'
      click_button "ログイン"
    end

    context 'メッセージボタンを押した場合' do
      it 'そのユーザーとのトークルームが作成される' do
        visit profile_path(@user2.id)
        click_on "メッセージを送る"
        expect(page).to have_content 'Talks'
        expect(page).to have_content 'Admin User'
      end
    end

    context 'メッセージを送信した場合' do
      it '入力したメッセージが表示される' do
        visit profile_path(@user2.id)
        click_on "メッセージを送る"
        fill_in 'message_content', with: 'こんにちは！'
        click_button "Send"
        expect(page).to have_content 'こんにちは！'
      end
    end
  end
end