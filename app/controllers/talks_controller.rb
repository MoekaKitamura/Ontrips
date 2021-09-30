class TalksController < ApplicationController
  def index
    @talks = Talk.all
  end

  def create
    if logged_in?
      # senderが送り主でreceiverが受取人
      # 該当のユーザ間での会話が過去に存在しているか？
      if Talk.between(params[:sender_id], params[:receiver_id]).present?
        # 存在した場合、その会話（チャットルーム）情報を取得
        @talk = Talk.between(params[:sender_id], params[:receiver_id]).first
      else
        # 過去に一件も存在しなかった場合、送られてきたparamsの値を利用して、会話（チャットルーム）情報を生成
        @talk = Talk.create!(talk_params)
      end
      # その会話のチャットルーム(メッセージの一覧画面)へ
      redirect_to talk_messages_path(@talk)
    end
  end

  private
  def talk_params
    params.permit(:sender_id, :receiver_id)
  end

end
