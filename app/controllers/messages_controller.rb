class MessagesController < ApplicationController
  before_action do
    # どの会話（チャットルーム）に存在するメッセージなのか？
    @talk = Talk.find(params[:talk_id])
  end

  def index
    @talks = Talk.all
    # 会話にひもづくメッセージを取得する
    @messages = @talk.messages
    if @messages.length > 10 #もしメッセージの数が10よりも大きければ
      @over_ten = true #10より大きいというフラグを有効にして
      @messages = Message.where(id: @messages[-10..-1].pluck(:id)) #メッセージを最新の10に絞る
      # 直近で登録されたメッセージの10件のidを取得し、そのidのmessageの配列をwhereメソッドで取得する
    end
    if params[:m] #params[:m]というパラメータをチェックした時、そこに値があれば（trueであれば）
      @over_ten = false #10より大きいというフラグを無効にして
      @messages = @talk.messages #会話にひもづくメッセージをすべて取得
    end
    if @messages.last #もし最新（最後）のメッセージが存在し、
      # (lastメソッドは、配列の最後の要素を返し空のときはnilを返す)
      @messages.where.not(user_id: current_user.id).update_all(read: true)
      #かつユーザIDが自分でなければ、今映っているメッセージを全て既読にする
    end
    # 表示するメッセージを作成日時順（投稿された順）に並び替える
    @messages = @messages.order(:created_at)
    # 新規投稿のメッセージ用の変数を作成する
    @message = @talk.messages.build
    @to = User.find(@message.talk.sender_id)
  end

  def create
    # 送られてきたparamsの値を利用して会話にひもづくメッセージを生成
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
