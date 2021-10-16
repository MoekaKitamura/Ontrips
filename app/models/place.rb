class Place < ApplicationRecord
  has_ancestry
  has_many :trips
  has_many :profiles

  geocoded_by :name_en
  after_validation :geocode
end
