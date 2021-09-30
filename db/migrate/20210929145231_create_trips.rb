class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.string :title, null: false
      t.integer :country, null: false
      t.integer :city
      t.date :start_on
      t.date :finish_on
      t.boolean :flexible, default: false
      t.text :description, null: false
      t.boolean :goal, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
