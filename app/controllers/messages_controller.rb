class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action do
    @talk = Talk.find(params[:talk_id])
  end

  def index
    @talks = Talk.all
    @messages = @talk.messages
    # 最新の10件のメッセージ取得
    if @messages.length > 10
      @over_ten = true
      @messages = Message.where(id: @talk.messages.order(created_at: :desc).limit(10).pluck(:id))
    end
    # 「以前のメッセージ」を押した場合、全件取得
    if params[:m]
      @over_ten = false
      @messages = @talk.messages
    end
    # 既読にする
    if @messages.last
      @messages.where.not(user_id: current_user.id).update_all(read: true)
    end
    @messages = @messages.order(:created_at)
    @message = @talk.messages.build
    @to = User.find(Talk.find(params[:talk_id]).receiver_id)
  end

  def create
    @message = @talk.messages.build(message_params)
    if @message.save
      redirect_to talk_messages_path(@talk)
    else
      render 'index'
    end
  end

  private
  def message_params
    params.require(:message).permit(:content, :user_id)
  end

end
