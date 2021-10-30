class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :blogs, dependent: :destroy 
  has_many :trips, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :talks, foreign_key: :sender_id, dependent: :destroy
  # has_many :talks, foreign_key: :receiver_id, dependent: :destroy

  def self.guest
    find_or_create_by(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "Guest"
      user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
  end

  def self.guest_admin
    find_or_create_by(email: 'guest_admin@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "Guest Admin"
      user.admin = true
      user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
  end

  validates :name, presence: true, length: { in: 2..25 }

  after_create :create_profile, :initial_message

  def create_profile
    create_profile!(id: id, place_id: 651)
  end

  def initial_message
    admin = User.find_by(email:"ontrips@ex.com")
    user = User.last
    talk = Talk.create(sender_id: admin.id, receiver_id: user.id)
    Message.create(talk_id: talk.id, user_id: admin.id, content: "こんにちは！新規ご登録ありがとうございます。")
    Message.create(talk_id: talk.id, user_id: admin.id, content: "このアプリで旅仲間を探し、さっそく旅に出よう！✈️")
    Message.create(talk_id: talk.id, user_id: admin.id, content: "お気づきの点、ご不明点がございましたらお気軽にご連絡ください。")
  end

end
