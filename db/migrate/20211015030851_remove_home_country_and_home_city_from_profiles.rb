class RemoveHomeCountryAndHomeCityFromProfiles < ActiveRecord::Migration[5.2]
  def change
    remove_column :profiles, :home_country, :integer
    remove_column :profiles, :home_city, :integer
  end
end
