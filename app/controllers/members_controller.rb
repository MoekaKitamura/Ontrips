class MembersController < ApplicationController
  def create
    member = current_user.members.create(trip_id: params[:trip_id], as: params[:as])
    if member.as == 1
      redirect_to trip_path(params[:trip_id]), notice: "#{member.trip.user.name}さんの旅に旅人として参加しました！"
    else
      redirect_to trip_path(params[:trip_id]), notice: "#{member.trip.user.name}さんの旅に現地人として参加しました！"
    end
  end

  def destroy
    member = current_user.members.find_by(id: params[:id]).destroy
    redirect_to trip_path(member.trip.id), notice: "#{member.trip.user.name}さんの旅への参加を解除しました。"
  end

end
