class Trip < ApplicationRecord
  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user

  has_many :members, dependent: :destroy
  has_many :member_users, through: :members, source: :user

  has_many :comments, dependent: :destroy

  belongs_to :place

end
