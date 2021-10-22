require 'rails_helper'

RSpec.describe Blog, type: :system do
  let!(:region) { Place.create(name_jp: "東アジア", name_en: "East Asia") }
  let!(:country) { region.children.create(code: "JP", name_jp: "日本", name_en: "Japan") }
  let!(:city) { country.children.create(code: "JP", name_jp: "福岡", name_en: "Fukuoka") }


  describe 'ブログ CRUD機能' do
    before do
      @user = FactoryBot.create(:user)
      profile = @user.build_profile(id: @user.id, place_id: city.id)
      profile.save!
      visit new_user_session_path
      fill_in :user_email, with: 'general@ex.com'
      fill_in :user_password, with: 'password'
      click_button "ログイン"
    end

    context 'ブログを投稿した場合' do
      it '作成した投稿内容が表示される' do
        visit new_blog_path
        fill_in 'blog_title', with: 'タイトル'
        fill_in 'blog_content', with: '内容'
        click_on "登録する"
        expect(page).to have_content 'タイトル'
        expect(page).to have_content 'ブログを作成しました！'
      end
    end

    context 'ブログの投稿に失敗した場合' do
      it 'エラーメッセージが表示される' do
        visit new_blog_path
        fill_in 'blog_title', with: ''
        fill_in 'blog_content', with: ''
        click_on "登録する"
        expect(page).to have_content 'タイトルを入力してください'
        expect(page).to have_content '内容を入力してください'
      end
    end

    context 'ブログを編集した場合' do
      it '変更内容が反映される' do
        blog = FactoryBot.create(:blog, user_id: @user.id)
        visit edit_blog_path(blog.id)
        fill_in 'blog_title', with: 'タイトル'
        fill_in 'blog_content', with: '変更したよ'
        click_on "更新する"
        expect(page).to have_content '変更したよ'
        expect(page).to have_content 'ブログを編集しました！'
      end
    end

    context 'ブログを削除した場合' do
      it '投稿が削除される' do
        blog = FactoryBot.create(:blog, user_id: @user.id)
        visit blog_path(blog.id)
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ブログを削除しました！'
        expect(page).to have_content 'Travel Experience'
      end
    end
  end

  describe 'ブログ 一覧・アクセス制限・検索機能' do
    before do
      @user1 = FactoryBot.create(:user)
      profile = @user1.build_profile(id: @user1.id, place_id: city.id)
      profile.save!
      @user2 = FactoryBot.create(:second_user)
      profile = @user2.build_profile(id: @user2.id, place_id: city.id)
      profile.save!
      visit new_user_session_path
      fill_in :user_email, with: 'general@ex.com'
      fill_in :user_password, with: 'password'
      click_button "ログイン"
    end

    let!(:blog1) { FactoryBot.create(:blog, user_id: @user1.id) }
    let!(:blog2) { FactoryBot.create(:blog2, user_id: @user2.id) }

    context '一覧画面に遷移した場合' do
      it '投稿されているブログが一覧で表示される' do
       visit blogs_path
       expect(page).to have_content 'Blog1'
       expect(page).to have_content 'Blog2'
      end
    end

    context '他人のブログの詳細ページにアクセスした場合' do
      it 'editとdeleteのボタンが表示されない' do
        visit blog_path(blog2.id)
        expect(page).not_to have_link '編集'
        expect(page).not_to have_link 'Delete'
      end
    end

    context '他人のブログの編集ページにアクセスした場合' do
      it 'エラーメッセージが出て、アクセスできない' do
        visit edit_blog_path(blog2.id)
        expect(page).to have_content '投稿者以外は編集できません'
      end
    end

    context 'タイトルで検索「Blog1」をした場合' do
      it '検索ワードでヒットするブログのみ表示される' do
        visit blogs_path
        fill_in 'q_title_or_content_cont', with: 'Blog1'
        click_on "検索"
        sleep 1.0
        blog_list = all('.blog_title')
        expect(blog_list[0]).to have_content 'Blog1'
        expect(blog_list[1]).not_to have_content 'Blog2'
      end
    end
  end
end