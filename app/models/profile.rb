class Profile < ApplicationRecord
  belongs_to :user

  mount_uploader :icon, IconUploader

  enum gender: { 男性: 1, 女性: 2, その他: 3 }
  enum home_country: { 日本: 1, オーストラリア: 2, アメリカ: 3 }
  enum home_city: { 福岡: 1, 東京: 2, 大阪: 3 }
  enum first_language: { 日本語: 1, 英語: 2, スペイン語: 3 }, _suffix: true #多重定義防止trueの場合は、属性名と同じ
  enum second_language: { 日本語: 1, 英語: 2, スペイン語: 3 }, _suffix: true
end
