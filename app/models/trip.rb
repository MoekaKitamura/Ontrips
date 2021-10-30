class Trip < ApplicationRecord
  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :favorite_users, through: :favorites, source: :user

  has_many :members, dependent: :destroy
  has_many :member_users, through: :members, source: :user

  has_many :comments, dependent: :destroy

  belongs_to :place

  validates :title, presence: true, length: { maximum: 35 }
  validates :description, length: { maximum: 1000 }
  validate :not_before_today, on: :create
  validate :not_before_start
  
  def not_before_today
    errors.add(:start_on, 'は本日以降で入力してください') if start_on.nil? || start_on < Date.today
  end
  
  def not_before_start
    if finish_on? && start_on?
      errors.add(:finish_on, 'は出発日以降で入力してください') if finish_on < start_on
    end
  end

end
