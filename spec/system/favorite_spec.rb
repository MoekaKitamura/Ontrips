require 'rails_helper'

RSpec.describe "Favorite", type: :system do
  let!(:from_region) { Place.create(name_jp: "東アジア", name_en: "East Asia") }
  let!(:from_country) { from_region.children.create(code: "JP", name_jp: "日本", name_en: "Japan") }
  let!(:from_city) { from_country.children.create(code: "JP", name_jp: "福岡", name_en: "Fukuoka") }
  let!(:to_region) { Place.create(name_jp: "オセアニア", name_en: "Oceania") }
  let!(:to_country) { to_region.children.create(code: "AU", name_jp: "オーストラリア", name_en: "Australia") }
  let!(:to_city1) { to_country.children.create(code: "AU", name_jp: "メルボルン", name_en: "Melbourne") }
  let!(:to_city2) { to_country.children.create(code: "AU", name_jp: "シドニー", name_en: "Sydney") }

  describe '旅行のお気に入り機能' do
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
  
    let!(:trip1) { FactoryBot.create(:trip, user_id: @user1.id, place_id: to_city1.id) }
    let!(:trip2) { FactoryBot.create(:second_trip, user_id: @user2.id, place_id: to_city2.id, goal:false) }

    context '旅行をお気に入りした場合' do
      it 'お気に入り登録され、ボタンが「お気に入り解除」に変わる' do
        visit trip_path(trip2.id)
        click_on "お気に入りする"
        expect(page).to have_content 'Admin Userさんの旅をお気に入りしました'
        expect(page).to have_content 'お気に入り解除'
      end
    end

    context 'お気に入りを解除した場合' do
      it 'お気に入りが解除され、ボタンが「お気に入りする」に変わる' do
        visit trip_path(trip2.id)
        click_on "お気に入りする"        
        click_on "お気に入り解除"
        expect(page).to have_content 'Admin Userさんの旅のお気に入りを解除しました'
        expect(page).to have_content 'お気に入りする'
      end
    end

    context '自分の投稿にアクセスした場合' do
      it 'お気に入りがボタンが表示されない' do
        visit trip_path(trip1.id)
        expect(page).not_to have_button 'お気に入りする'
      end
    end

  end
end