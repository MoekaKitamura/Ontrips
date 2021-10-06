class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :blogs, dependent: :destroy 
  has_many :trips, dependent: :destroy
  has_one :profiles, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :comments, dependent: :destroy

  def self.guest
    find_or_create_by(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲスト"
      user.confirmed_at = Time.now  # Confirmable を使用している場合は必要
    end
  end

end
