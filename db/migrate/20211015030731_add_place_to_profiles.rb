class AddPlaceToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_reference :profiles, :place, foreign_key: true
  end
end
