require 'rails_helper'

RSpec.describe Trip, type: :system do
  let!(:from_region) { Place.create(name_jp: "東アジア", name_en: "East Asia") }
  let!(:from_country) { from_region.children.create(code: "JP", name_jp: "日本", name_en: "Japan") }
  let!(:from_city) { from_country.children.create(code: "JP", name_jp: "福岡", name_en: "Fukuoka") }
  let!(:to_region) { Place.create(name_jp: "オセアニア", name_en: "Oceania") }
  let!(:to_country) { to_region.children.create(code: "AU", name_jp: "オーストラリア", name_en: "Australia") }
  let!(:to_city1) { to_country.children.create(code: "AU", name_jp: "メルボルン", name_en: "Melbourne") }
  let!(:to_city2) { to_country.children.create(code: "AU", name_jp: "シドニー", name_en: "Sydney") }

  describe '旅行掲示板 CRUD機能' do
    before do
      @user = FactoryBot.create(:second_user)
      profile = @user.build_profile(id: @user.id, place_id: from_city.id)
      profile.save!
      visit new_user_session_path
      fill_in :user_email, with: 'admin@ex.com'
      fill_in :user_password, with: 'password'
      click_button "ログイン"
    end

    context '旅行を投稿した場合' do
      it '作成した投稿内容が表示される' do
        visit new_trip_path
        fill_in 'trip_title', with: 'タイトル'
        select 'オセアニア', from: 'place_region'
        select 'オーストラリア', from: 'place_country'
        select 'シドニー', from: 'place_city'
        fill_in 'trip_start_on', with: '002022-07-11'
        fill_in 'trip_finish_on', with: '002022-08-11'
        click_on "登録する"
        expect(page).to have_content 'タイトル'
        expect(page).to have_content '旅行を作成しました！'
      end
    end

    context '旅行を編集した場合' do
      it '変更内容が反映される' do
        trip = FactoryBot.create(:trip, user_id: @user.id, place_id: to_city1.id)
        visit edit_trip_path(trip.id)
        fill_in 'trip_title', with: 'タイトル変更'
        select 'オセアニア', from: 'place_region'
        select 'オーストラリア', from: 'place_country'
        select 'シドニー', from: 'place_city'
        fill_in 'trip_start_on', with: '002022-07-11'
        fill_in 'trip_finish_on', with: '002022-08-11'
        click_on "更新する"
        expect(page).to have_content 'タイトル変更'
      end
    end

    context '旅行を削除した場合' do
      it '投稿が削除される' do
        trip = FactoryBot.create(:trip, user_id: @user.id, place_id: to_city1.id)
        visit trip_path(trip.id)
        click_on "Delete"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '旅行を削除しました！'
        expect(page).to have_content 'Find Trips'
      end
    end
  end

  describe '旅行一覧表示機能' do
    before do
      @user = FactoryBot.create(:second_user)
      profile = @user.build_profile(id: @user.id, place_id: from_city.id)
      profile.save!
      visit new_user_session_path
      fill_in :user_email, with: 'admin@ex.com'
      fill_in :user_password, with: 'password'
      click_button "ログイン"
    end
    
    let!(:trip1) { FactoryBot.create(:trip, user_id: @user.id, place_id: to_city1.id) }
    let!(:trip2) { FactoryBot.create(:second_trip, user_id: @user.id, place_id: to_city2.id) }
    
    context '一覧画面に遷移した場合' do
      it '作成した掲示板が表示される' do
       visit trips_path
       expect(page).to have_content 'Trip1'
       expect(page).to have_content 'Trip2'
      end
    end
    # context '掲示板が作成日時の降順に並んでいる場合(デフォルト)' do # 作成順が毎回違うため、削除
    #   it 'シドニー(2個目)が一番上に表示される' do
    #     visit trips_path
    #     trip_list = all('.trip_title')
    #     expect(trip_list[0]).to have_content 'Trip2'
    #     expect(trip_list[1]).to have_content 'Trip1'
    #   end
    # end
    context '出発日の昇順に並び替えをした場合' do
      it '出発日が1番早い、メルボルンが一番上に表示される' do
        visit trips_path
        click_on "出発日順に並び替え"
        sleep 5
        trip_list = all('.trip_title')
        expect(trip_list[0]).to have_content 'Trip1'
        expect(trip_list[1]).to have_content 'Trip2'
      end
    end
    context '「シドニー」であいまい検索をした場合' do
      it '検索ワードでヒットするシドニーの旅行のみ表示される' do
        visit trips_path
        fill_in 'q_place_name_jp_or_place_name_en_or_title_or_description_cont', with: 'シドニー'
        click_on "検索"
        trip_list = all('.trip_title')
        expect(trip_list[0]).to have_content 'Trip2'
        expect(trip_list[1]).not_to have_content 'Trip1'
      end
    end
  end
end