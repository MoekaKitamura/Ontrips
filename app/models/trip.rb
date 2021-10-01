class Trip < ApplicationRecord
  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user

  has_many :members, dependent: :destroy
  has_many :member_users, through: :members, source: :user

  has_many :comments, dependent: :destroy

  enum country: { 日本: 1, オーストラリア: 2, アメリカ: 3 }
  enum city: { 福岡: 1, 東京: 2, 大阪: 3 }
end
