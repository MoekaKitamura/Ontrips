require 'rails_helper'

RSpec.describe Talk, type: :model do
  before do
    @user1 = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:second_user)
  end

  describe 'バリデーションのテスト' do
    context 'senderとreceiverの組み合わせが初めての場合' do
      it 'バリデーションが通る' do
        @talk1 = Talk.new(
          sender_id: @user1.id,
          receiver_id: @user2.id,
        )
        expect(@talk1).to be_valid
      end
    end
    context 'senderとreceiverの組み合わせが同じ場合' do
      it 'バリデーションにひっかかる' do
        talk1 = Talk.create(
          sender_id: @user1.id,
          receiver_id: @user2.id,
        )
        talk2 = Talk.new(
          sender_id: talk1.sender.id,
          receiver_id: talk1.receiver.id,
        )
        expect(talk2).not_to be_valid
      end
    end
    
  end
end
