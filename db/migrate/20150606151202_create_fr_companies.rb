class CreateFrCompanies < ActiveRecord::Migration
  def change
    create_table :fr_companies do |t|
      t.text :siret, null: false
      t.text :ville
      t.text :code_postal
      t.text :numero_et_voie
      t.text :gmap_geocoded_address
      t.boolean :gmap_null_result
      t.boolean :gmap_partial_match
      t.text :gmap_longitude
      t.text :gmap_latitude
      t.text :gmap_location_type
      t.text :gmap_street_number
      t.text :gmap_locality
      t.text :gmap_route
      t.text :gmap_country_code
      t.text :gmap_postal_code
      t.text :gmap_formatted_address
      t.text :gmap_json
      t.timestamps null: true
    end
    add_index :fr_companies, :siret, unique: true
    add_index :fr_companies, :code_postal
    add_index :fr_companies, :gmap_null_result
    add_index :fr_companies, :gmap_partial_match
    add_index :fr_companies, :gmap_location_type
  end
end
