class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :icon
      t.integer :gender
      t.date :birthday
      t.integer :home_country
      t.integer :home_city
      t.integer :first_language
      t.integer :second_language
      t.text :introduction
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
