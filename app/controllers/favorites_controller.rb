class FavoritesController < ApplicationController
  def create
    favorite = current_user.favorites.create(trip_id: params[:trip_id])
    redirect_to trips_path, notice: "#{favorite.trip.user.name}さんの投稿をいいねしました"
  end

  def destroy
    favorite = current_user.favorites.find_by(id: params[:id]).destroy
    redirect_to trips_path, notice: "#{favorite.trip.user.name}さんの投稿をいいね解除しました"
  end
end
