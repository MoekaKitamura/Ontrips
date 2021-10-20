require 'rails_helper'

RSpec.describe "Member", type: :system do
  let!(:from_region) { Place.create(name_jp: "東アジア", name_en: "East Asia") }
  let!(:from_country) { from_region.children.create(code: "JP", name_jp: "日本", name_en: "Japan") }
  let!(:from_city) { from_country.children.create(code: "JP", name_jp: "福岡", name_en: "Fukuoka") }
  let!(:to_region) { Place.create(name_jp: "オセアニア", name_en: "Oceania") }
  let!(:to_country) { to_region.children.create(code: "AU", name_jp: "オーストラリア", name_en: "Australia") }
  let!(:to_city1) { to_country.children.create(code: "AU", name_jp: "メルボルン", name_en: "Melbourne") }
  let!(:to_city2) { to_country.children.create(code: "AU", name_jp: "シドニー", name_en: "Sydney") }

  describe '旅行の参加機能' do
    before do
      @user1 = FactoryBot.create(:user)
      profile = @user1.build_profile(id: @user1.id, place_id: from_city.id)
      profile.save!
      @user2 = FactoryBot.create(:second_user)
      profile = @user2.build_profile(id: @user2.id, place_id: from_city.id)
      profile.save!
      visit new_user_session_path
      fill_in :user_email, with: 'general@ex.com'
      fill_in :user_password, with: 'password'
      click_button "ログイン"
    end
  
    let!(:trip1) { FactoryBot.create(:trip, user_id: @user2.id, place_id: to_city1.id) }
    let!(:trip2) { FactoryBot.create(:second_trip, user_id: @user2.id, place_id: to_city2.id, goal:true) }

    context '旅行者として参加した場合' do
      it '旅のメンバーに名前が表示、ボタンが「参加キャンセル」に変わる' do
        visit trip_path(trip1.id)
        click_on "一緒に旅をする"
        expect(page).to have_content 'Admin Userさんの旅に旅行者として参加しました！'
        expect(page).to have_content 'General User'
        expect(page).to have_content '参加キャンセル'
      end
    end

    context 'ローカルとして参加した場合' do
      it '旅のメンバーに名前が表示、ボタンが「参加キャンセル」に変わる' do
        visit trip_path(trip1.id)
        click_on "ローカルとして参加"
        expect(page).to have_content 'Admin Userさんの旅にローカルとして参加しました！'
        expect(page).to have_content 'General User'
        expect(page).to have_content '参加キャンセル'
      end
    end

    context '参加をキャンセルした場合' do
      it 'メンバーからはずれ、参加する前に戻る' do
        visit trip_path(trip1.id)
        click_on "一緒に旅をする"        
        click_on "参加キャンセル"
        expect(page).to have_content 'Admin Userさんの旅への参加をキャンセルしました'
      end
    end

    context '終了済みの旅行に参加しようとした場合' do
      it 'エラーメッセージが出て、参加できない' do
        visit trip_path(trip2.id)
        click_on "一緒に旅をする"
        expect(page).to have_content 'この旅行は終了しています。終了した旅行に参加できません'
        expect(page).to have_content '一緒に旅をする'
      end
    end

  end
end