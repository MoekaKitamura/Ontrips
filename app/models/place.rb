class Place < ApplicationRecord
  has_ancestry
  has_many :trips
  has_many :profiles
end
