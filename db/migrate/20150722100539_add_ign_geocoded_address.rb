class AddIgnGeocodedAddress < ActiveRecord::Migration
  def change
    add_column :fr_companies, :ign_geocoded_address, :text
    add_index :fr_companies, :ign_geocoded_address
    add_index :fr_companies, :gmap_geocoded_address
  end
end
