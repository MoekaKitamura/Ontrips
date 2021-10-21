require 'rails_helper'

RSpec.describe Comment, type: :model do

  before do
    @user = FactoryBot.create(:user)
    @region = FactoryBot.create(:region)
    @country = FactoryBot.create(:country)
    @city = FactoryBot.create(:city)
    @trip = FactoryBot.create(:trip, user_id: @user.id, place_id: @city.id)
  end

  describe 'バリデーションのテスト' do
    context 'コメント内容が未入力の場合' do
      it 'バリデーションにひっかかる' do
        comment = Comment.new(
          content: "",
          trip_id: @trip.id,
          user_id: @user.id
        )
        expect(comment).not_to be_valid
      end
    end

    context 'コメントが入力された場合' do
      it 'バリデーションが通る' do
        comment = Comment.new(
          content: "コメント内容",
          trip_id: @trip.id,
          user_id: @user.id
        )
        expect(comment).to be_valid
      end
    end
  end
end