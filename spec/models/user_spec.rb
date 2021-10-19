require 'rails_helper'

RSpec.describe User, type: :model do  

  describe 'バリデーションのテスト' do
    context '名前が未入力の場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: '', email:'user@ex.com', password:'password', confirmed_at: Time.now)
        expect(user).not_to be_valid
      end
    end
    context '名前が1文字のみの場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: 'a', email:'user@ex.com', password:'password', confirmed_at: Time.now)
        expect(user).not_to be_valid
      end
    end
    context '名前が25文字以上のみの場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: 'over twenty-five letter name', email:'user@ex.com', password:'password', confirmed_at: Time.now)
        expect(user).not_to be_valid
      end
    end
    context 'メールアドレスが未入力の場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: 'user', email:'', password:'password', confirmed_at: Time.now)
        expect(user).not_to be_valid
      end
    end
    context 'メールアドレスが形式と違う場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: 'user', email:'user.com', password:'password', confirmed_at: Time.now)
        expect(user).not_to be_valid
      end
    end
    context 'パスワードが未入力の場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: 'user', email:'user@ex.com', password:'', confirmed_at: Time.now)
        expect(user).not_to be_valid
      end  
    end
    context 'パスワードが6文字未満の場合' do
      it 'バリデーションにひっかかる' do
        user = User.new(name: 'user', email:'user@ex.com', password:'word', confirmed_at: Time.now)
        expect(user).not_to be_valid
      end  
    end
    context '名前、メールアドレス、パスワードが入力されてる場合' do
      it 'バリデーションが通る' do
        user = User.new(name: 'user', email:'user@ex.com', password:'password', confirmed_at: Time.now)
        expect(user).to be_valid
      end
    end
  end
end
