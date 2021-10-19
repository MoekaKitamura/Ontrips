require 'rails_helper'

RSpec.describe Message, type: :model do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:second_user)
    @talk = Talk.create(
      sender_id: @user1.id,
      receiver_id: @user2.id,
    )
  end
  describe 'バリデーションのテスト' do
    context 'メッセージが未入力の場合' do
      it 'バリデーションにひっかかる' do
        message = Message.new(
          content: "",
          talk_id: @talk.id,
          user_id: @user1.id,
          read: true,
        )
        expect(message).not_to be_valid
      end
    end
    context 'メッセージが入力された場合' do
      it 'バリデーションが通る' do
        message = Message.new(
          content: "こんにちは",
          talk_id: @talk.id,
          user_id: @user1.id,
          read: true,
        )
        expect(message).to be_valid
      end
    end
  end
end