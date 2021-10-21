require 'rails_helper'

RSpec.describe Comment, type: :system do
  let!(:from_region) { Place.create(name_jp: "東アジア", name_en: "East Asia") }
  let!(:from_country) { from_region.children.create(code: "JP", name_jp: "日本", name_en: "Japan") }
  let!(:from_city) { from_country.children.create(code: "JP", name_jp: "福岡", name_en: "Fukuoka") }
  let!(:to_region) { Place.create(name_jp: "オセアニア", name_en: "Oceania") }
  let!(:to_country) { to_region.children.create(code: "AU", name_jp: "オーストラリア", name_en: "Australia") }
  let!(:to_city1) { to_country.children.create(code: "AU", name_jp: "メルボルン", name_en: "Melbourne") }
  let!(:to_city2) { to_country.children.create(code: "AU", name_jp: "シドニー", name_en: "Sydney") }
  
  describe 'コメント CRUD機能' do
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

    context 'コメントを投稿した場合' do
      it '投稿したコメントが表示される' do
        visit trip_path(trip1.id)
        fill_in 'comment_content', with: 'Nice!!'
        click_on "Comment!"
        expect(page).to have_content 'Nice!!'
      end
    end

    context 'コメントを入力せずに送信した場合' do
      it '送信できず、コメントが表示されない' do
        visit trip_path(trip1.id)
        fill_in 'comment_content', with: ''
        click_on "Comment!"
        comment_list = all('.comment li')
        expect(comment_list).not_to have_selector '.comment li'
        expect(page).to have_content 'コメントを入力してください'
      end
    end

    context 'コメントを編集した場合' do
      it '変更内容が反映される' do
        comment = Comment.create(content: "NICE!!", user_id: @user.id, trip_id: trip1.id)
        visit trip_path(trip1.id)
        find("a[href='/trips/#{trip1.id}/comments/#{comment.id}/edit'").click
        # fill_in 'comment_content_<%= trip1.id %>', with: 'AWESOME!!'
        fill_in "comment_content_#{trip1.id}", with: 'AWESOME!!'
        click_on "更新する"
        expect(page).to have_content 'AWESOME!!'
      end
    end

    context 'コメントを削除した場合' do
      it 'コメントが表示されなくなる' do
        comment = Comment.create(content: "NICE!!", user_id: @user.id, trip_id: trip1.id)
        visit trip_path(trip1.id)
        find("a[href='/trips/#{trip1.id}/comments/#{comment.id}'").click
        page.driver.browser.switch_to.alert.accept
        expect(page).not_to have_content 'NICE!!'
      end
    end
  end
end