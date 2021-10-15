class Place < ApplicationRecord
  has_ancestry
  has_many :trips
end
