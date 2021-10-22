require 'rails_helper'

RSpec.describe Profile, type: :system do
  let!(:region) { Place.create(name_jp: "東アジア", name_en: "East Asia") }
  let!(:country) { region.children.create(code: "JP", name_jp: "日本", name_en: "Japan") }
  let!(:city1) { country.children.create(code: "JP", name_jp: "福岡", name_en: "Fukuoka") }
  let!(:city2) { country.children.create(code: "JP", name_jp: "東京", name_en: "Tokyo") }

  describe 'ユーザープロフィールのテスト' do
    before do
      @user1 = FactoryBot.create(:user)
      @profile1 = @user1.build_profile(id: @user1.id, place_id: city1.id)
      @profile1.save!
      @user2 = FactoryBot.create(:second_user)
      @profile2 = @user2.build_profile(id: @user2.id, place_id: city2.id)
      @profile2.save!
      visit new_user_session_path
      fill_in :user_email, with: 'general@ex.com'
      fill_in :user_password, with: 'password'
      click_button "ログイン"
    end

    context '一覧画面に遷移した場合' do
      it 'ユーザーのプロフィールが一覧で表示される' do
       visit profiles_path
       expect(page).to have_content 'General User'
       expect(page).to have_content 'Admin User'
      end
    end
    context '日本語「東京」であいまい検索をした場合' do
      it '検索ワードでヒットする東京在住のユーザーが表示される' do
        visit profiles_path
        fill_in 'q_place_name_jp_or_place_name_en_or_introduction_cont', with: '東京'
        click_on "検索"
        sleep 1.0
        profile_list = all('.profile__card h3')
        expect(profile_list[0]).to have_content 'Admin User'
        expect(profile_list[1]).not_to have_content 'General User'
      end
    end
    context '日本語「Tokyo」であいまい検索をした場合' do
      it '検索ワードでヒットする東京在住のユーザーが表示される' do
        visit profiles_path
        fill_in 'q_place_name_jp_or_place_name_en_or_introduction_cont', with: 'Tokyo'
        click_on "検索"
        sleep 1.0
        profile_list = all('.profile__card h3')
        expect(profile_list[0]).to have_content 'Admin User'
        expect(profile_list[1]).not_to have_content 'General User'
      end
    end
    context '自分のプロフィールページにアクセスした場合' do
      it 'Editリンクは出るけど、Deleteのリンクは表示されない' do
        visit profile_path(@profile1.id)
        expect(page).to have_link '編集'
        expect(page).not_to have_link 'Delete'
      end
    end
    context 'プロフィールを編集した場合' do
      it '変更内容が反映される' do
        visit edit_profile_path(@profile1.id)
        choose '女性'
        select '東アジア', from: 'place_region'
        select '日本', from: 'place_country'
        select '東京', from: 'place_city'
        select '日本語', from: 'profile_first_language'
        select '英語', from: 'profile_second_language'
        fill_in 'profile_introduction', with: '居住地を福岡から東京へ変更'
        click_on "更新する"
        expect(page).to have_content '女性'
        expect(page).to have_content '日本'
        expect(page).to have_content '東京'
        expect(page).to have_content '居住地を福岡から東京へ変更'
      end
    end
    context '他人のプロフィールページにアクセスした場合' do
      it 'Edit,Deleteのリンクが表示されない' do
        visit profile_path(@profile2.id)
        expect(page).not_to have_link '編集'
        expect(page).not_to have_link 'Delete'
      end
    end
    context '他人のプロフィール編集ページにアクセスした場合' do
      it 'エラーメッセージが出て、アクセスできない' do
        visit edit_profile_path(@profile2.id)
        expect(page).to have_content 'ユーザー本人以外は編集できません'
      end
    end
  end
end