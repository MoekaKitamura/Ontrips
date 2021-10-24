class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    favorite = current_user.favorites.create(trip_id: params[:trip_id])
    redirect_to trip_path(params[:trip_id]), notice: "#{favorite.trip.user.name}さんの旅をお気に入りしました"
  end

  def destroy
    favorite = current_user.favorites.find_by(id: params[:id]).destroy
    redirect_to trip_path(favorite.trip.id), notice: "#{favorite.trip.user.name}さんの旅のお気に入りを解除しました"
  end
end