class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :blogs, dependent: :destroy 
  has_many :trips, dependent: :destroy
  has_one :profiles, dependent: :destroy
  has_many :favorites, dependent: :destroy
end
