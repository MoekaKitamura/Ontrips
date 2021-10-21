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

    context 'タイトルなしで旅行を投稿した場合' do
      it '投稿ができず、エラー文が表示される' do
        visit new_trip_path
        fill_in 'trip_title', with: ''
        select 'オセアニア', from: 'place_region'
        select 'オーストラリア', from: 'place_country'
        select 'シドニー', from: 'place_city'
        fill_in 'trip_start_on', with: '002022-07-11'
        fill_in 'trip_finish_on', with: '002022-08-11'
        click_on "登録する"
        expect(current_path).to eq new_trip_path
        expect(page).to have_content 'タイトルを入力してください。'
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

  describe '旅行 一覧・アクセス制限・検索機能' do
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
    let!(:trip2) { FactoryBot.create(:second_trip, user_id: @user2.id, place_id: to_city2.id) }
    
    context '一覧画面に遷移した場合' do
      it '投稿されている旅行が一覧で表示される' do
       visit trips_path
       expect(page).to have_content 'Trip1'
       expect(page).to have_content 'Trip2'
      end
    end

    context 'メルボルン旅行の詳細ページにアクセスした場合' do
      it '似ている旅行としてシドニー旅行へのリンクが表示される' do
        visit trip_path(trip1.id)
        expect(page).to have_link 'Trip2'
      end
    end

    context '自分が投稿した旅行の詳細ページにアクセスした場合' do
      it '「旅を終了する」ボタンが表示される' do
        visit trip_path(trip1.id)
        expect(page).to have_link '旅を終了する'
      end
    end

    context '自分が投稿した旅行を終了させた場合' do
      it 'ステータスが変わり、ボタンが「再開する」に変わる' do
        visit trip_path(trip1.id)
        click_on '旅を終了する'
        expect(page).to have_link '再開する'
        expect(page).to have_content 'ステータスを変更しました！'
      end
    end
    
    context '他人の旅行の詳細ページにアクセスした場合' do
      it '旅を終了する,Edit,Deleteのリンクが表示されない' do
        visit trip_path(trip2.id)
        expect(page).not_to have_link '旅を終了する'
        expect(page).not_to have_link 'Edit'
        expect(page).not_to have_link 'Delete'
      end
    end

    context '他人の旅行の編集ページにアクセスした場合' do
      it 'エラーメッセージが出て、アクセスできない' do
        visit edit_trip_path(trip2.id)
        expect(page).to have_content '投稿者以外は編集できません'
      end
    end

    context '出発日の昇順に並び替えをした場合' do
      it '出発日が1番早い、メルボルンが一番上に表示される' do
        visit trips_path
        click_on "出発日順に並び替え"
        sleep 1.0
        trip_list = all('.trip_title')
        expect(trip_list[0]).to have_content 'Trip1'
        expect(trip_list[1]).to have_content 'Trip2'
      end
    end

    context '日本語「シドニー」であいまい検索をした場合' do
      it '検索ワードでヒットするシドニーの旅行のみ表示される' do
        visit trips_path
        fill_in 'q_place_name_jp_or_place_name_en_or_title_or_description_cont', with: 'シドニー'
        click_on "検索"
        trip_list = all('.trip_title')
        expect(trip_list[0]).to have_content 'Trip2'
        expect(trip_list[1]).not_to have_content 'Trip1'
      end
    end

    context '英語「Sydney」であいまい検索をした場合' do
      it '検索ワードでヒットするシドニーの旅行のみ表示される' do
        visit trips_path
        fill_in 'q_place_name_jp_or_place_name_en_or_title_or_description_cont', with: 'Sydney'
        click_on "検索"
        trip_list = all('.trip_title')
        expect(trip_list[0]).to have_content 'Trip2'
        expect(trip_list[1]).not_to have_content 'Trip1'
      end
    end

    context '出発日が2022年の旅行で絞り込み検索をした場合' do
      it 'ヒットするメルボルンの旅行のみ表示される' do
        visit trips_path
        fill_in 'q_start_on_gteq', with: '002022-01-01'
        fill_in 'q_finish_on_lteq', with: '002022-12-31'
        click_on "検索"
        trip_list = all('.trip_title')
        expect(trip_list[0]).to have_content 'Trip1'
        expect(trip_list[1]).not_to have_content 'Trip2'
      end
    end
  end
end