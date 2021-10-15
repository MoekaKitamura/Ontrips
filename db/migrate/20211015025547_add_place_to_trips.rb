class AddPlaceToTrips < ActiveRecord::Migration[5.2]
  def change
    add_reference :trips, :place, foreign_key: true
  end
end
