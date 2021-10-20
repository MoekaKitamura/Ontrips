require 'rails_helper'

RSpec.describe Trip, type: :model do

  before do
    @user = FactoryBot.create(:user)
    @region = FactoryBot.create(:region)
    @country = FactoryBot.create(:country)
    @city = FactoryBot.create(:city)
  end

  describe 'バリデーションのテスト' do
    context 'タイトルが未入力の場合' do
      it 'バリデーションにひっかかる' do
        trip = Trip.new(
          title: "",
          start_on: Date.today << -1,
          finish_on: Date.today << -2,
          flexible: true,
          description: "福岡",
          goal: false,
          user_id: @user.id,
          place_id: @city.id
        )
        expect(trip).not_to be_valid
      end
    end

    context '目的地が未入力の場合' do
      it 'バリデーションにひっかかる' do
        trip = Trip.new(
          title: "タイトル",
          start_on: Date.today << -1,
          finish_on: Date.today << -2,
          flexible: true,
          description: "目的地不明",
          goal: false,
          user_id: @user.id,
          place_id: ''
        )
        expect(trip).not_to be_valid
      end
    end

    context '目的地が国まで選択された場合' do
      it 'バリデーションが通る' do
        trip = Trip.new(
          title: "タイトル",
          start_on: Date.today << -1,
          finish_on: Date.today << -2,
          flexible: true,
          description: "日本",
          goal: false,
          user_id: @user.id,
          place_id: @country.id
        )
        expect(trip).to be_valid
      end
    end

    context '目的地が都市まで選択された場合' do
      it 'バリデーションが通る' do
        trip = Trip.new(
          title: "タイトル",
          start_on: Date.today << -1,
          finish_on: Date.today << -2,
          flexible: true,
          description: "福岡",
          goal: false,
          user_id: @user.id,
          place_id: @city.id
        )
        expect(trip).to be_valid
      end
    end

    context '出発日と到着日が未入力の場合' do
      it 'バリデーションにひっかかる' do
        trip = Trip.new(
          title: "タイトル",
          start_on: "",
          finish_on: "",
          flexible: true,
          description: "福岡",
          goal: false,
          user_id: @user.id,
          place_id: @city.id
        )
        expect(trip).not_to be_valid
      end
    end

    context '出発日が入力、かつ到着日が未入力の場合' do
      it 'バリデーションが通る' do
        trip = Trip.new(
          title: "タイトル",
          start_on: Date.today << -1,
          finish_on: "",
          flexible: true,
          description: "福岡",
          goal: false,
          user_id: @user.id,
          place_id: @city.id
        )
        expect(trip).to be_valid
      end
    end

    context '出発日が未入力、到着日が入力された場合' do
      it 'バリデーションにひっかかる' do
        trip = Trip.new(
          title: "タイトル",
          start_on: "",
          finish_on: Date.today << -1,
          flexible: true,
          description: "福岡",
          goal: false,
          user_id: @user.id,
          place_id: @city.id
        )
        expect(trip).not_to be_valid
      end
    end

    context '出発日が過去の場合' do
      it 'バリデーションにひっかかる' do
        trip = Trip.new(
          title: "タイトル",
          start_on: Date.today << 1,
          finish_on: "",
          flexible: true,
          description: "福岡",
          goal: false,
          user_id: @user.id,
          place_id: @city.id
        )
        expect(trip).not_to be_valid
      end
    end

    context '到着日が出発日より過去の場合' do
      it 'バリデーションにひっかかる' do
        trip = Trip.new(
          title: "タイトル",
          start_on: Date.today << -2,
          finish_on: Date.today << -1,
          flexible: true,
          description: "福岡",
          goal: false,
          user_id: @user.id,
          place_id: @city.id
        )
        expect(trip).not_to be_valid
      end
    end
  end
end