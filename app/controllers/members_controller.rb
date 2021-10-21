class MembersController < ApplicationController
  before_action :authenticate_user!

  def create
    @trip = Trip.find(params[:trip_id])
    unless @trip.goal
      member = current_user.members.create(trip_id: params[:trip_id], as: params[:as])
      if member.as == 1
        redirect_to trip_path(params[:trip_id]), notice: "#{member.trip.user.name}さんの旅に旅行者として参加しました！"
      else
        redirect_to trip_path(params[:trip_id]), notice: "#{member.trip.user.name}さんの旅にローカルとして参加しました！"
      end
    else
      redirect_to @trip, alert: 'この旅行は終了しています。終了した旅行に参加できません'
    end
    
  end

  def destroy
    member = current_user.members.find_by(id: params[:id]).destroy
    redirect_to trip_path(member.trip.id), notice: "#{member.trip.user.name}さんの旅への参加をキャンセルしました"
  end

end
