class Talk < ApplicationRecord
  # 会話はUserの概念をsenderとreceiverに分けた形でアソシエーションする。
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'
  # 一つの会話はメッセージをたくさん含む一対多。
  has_many :messages, dependent: :destroy
  # [:sender_id, :receiver_id]が同じ組み合わせで保存されないようにするためのバリデーションを設定。
  # DBでも制限かけたけど、バリデーションも設定。DBのエラーとなる前にアプリケーション側でエラーを検知し、ユーザーに間違いを知らせる
  validates_uniqueness_of :sender_id, scope: :receiver_id

  # 組み合わせを定義 senderとreceiverの間柄が逆でも問題がない処理
  scope :between, -> (sender_id,receiver_id) do
    where("(talks.sender_id = ? AND talks.receiver_id =?) OR (talks.sender_id = ? AND  talks.receiver_id =?)", sender_id,receiver_id, receiver_id, sender_id)
  end

  # current_userと、current_userの相手となるuserの情報を取得
  def target_user(current_user)
    if sender_id == current_user.id
      # User.find(receiver_id)
      User.find_by(id: receiver_id)
    elsif receiver_id == current_user.id
      # User.find(sender_id)
      User.find_by(id: sender_id)
    end
  end
end
