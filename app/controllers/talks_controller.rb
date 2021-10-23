class TalksController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @talks = Talk.all
  end

  def create
    if Talk.between(params[:sender_id], params[:receiver_id]).present?
      @talk = Talk.between(params[:sender_id], params[:receiver_id]).first
    else
      @talk = Talk.create!(talk_params)
    end
    redirect_to talk_messages_path(@talk)
  end

  private
  def talk_params
    params.permit(:sender_id, :receiver_id)
  end

end
