class RemoveCountryAndCityFromTrips < ActiveRecord::Migration[5.2]
  def change
    remove_column :trips, :country, :integer
    remove_column :trips, :city, :integer
  end
end
