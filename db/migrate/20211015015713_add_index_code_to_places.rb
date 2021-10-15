class AddIndexCodeToPlaces < ActiveRecord::Migration[5.2]
  def change
    add_index  :places, :code
  end
end