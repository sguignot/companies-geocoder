class CreateIgnGeocodes < ActiveRecord::Migration
  def change
    create_table :ign_geocodes do |t|
      t.text :geocoded_address, null: false
      t.integer :n_results, null: false
      t.text :pos
      t.text :latitude
      t.text :longitude
      t.text :building_number
      t.text :street
      t.text :municipality
      t.text :qualite
      t.text :departement
      t.text :bbox
      t.text :commune
      t.text :insee
      t.text :territoire
      t.text :id_ign
      t.text :id_tr
      t.text :postal_code
      t.text :match_accuracy
      t.text :match_type
      t.text :ign_xml, null: false

      t.timestamps null: false
    end
    add_index :ign_geocodes, :geocoded_address, unique: true
    add_index :ign_geocodes, :n_results
    add_index :ign_geocodes, :qualite
    add_index :ign_geocodes, :match_accuracy
    add_index :ign_geocodes, :match_type
  end
end
