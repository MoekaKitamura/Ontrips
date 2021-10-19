require 'rails_helper'

RSpec.describe Trip, type: :model do

  before do
    @user = FactoryBot.create(:user)
    @region = FactoryBot.create(:region)
    @country = FactoryBot.create(:country)
    @city = FactoryBot.create(:city)
  end

  describe 'バリデーションのテスト' do
    context '目的地が未入力の場合' do
      it 'バリデーションにひっかかる' do
        trip = Trip.new(
          title: "タイトル",
          start_on: Time.now,
          finish_on: Time.now,
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
          start_on: Time.now,
          finish_on: Time.now,
          flexible: true,
          description: "バンコク",
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
          start_on: Time.now,
          finish_on: Time.now,
          flexible: true,
          description: "バンコク",
          goal: false,
          user_id: @user.id,
          place_id: @city.id
        )
        expect(trip).to be_valid
      end
    end
  end
end