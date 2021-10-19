require 'rails_helper'

RSpec.describe Blog, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end
  describe 'バリデーションのテスト' do
    context 'タイトルが未入力の場合' do
      it 'バリデーションにひっかかる' do
        blog = Blog.new(
          title: "",
          content: "内容",
          user_id: @user.id,
        )
        expect(blog).not_to be_valid
      end
    end
    context 'タイトルが35文字以上の場合' do
      it 'バリデーションにひっかかる' do
        blog = Blog.new(
          title: "over thirty-five letter very long title",
          content: "内容",
          user_id: @user.id,
        )
        expect(blog).not_to be_valid
      end
    end
    context '内容が未入力の場合' do
      it 'バリデーションにひっかかる' do
        blog = Blog.new(
          title: "タイトル",
          content: "",
          user_id: @user.id,
        )
        expect(blog).not_to be_valid
      end
    end
    context 'タイトル、内容が入力された場合' do
      it 'バリデーションが通る' do
        blog = Blog.new(
          title: "タイトル",
          content: "内容",
          user_id: @user.id,
        )
        expect(blog).to be_valid
      end
    end
  end
end
