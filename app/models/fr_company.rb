class FrCompany < ActiveRecord::Base
  has_one :ign_geocode, primary_key: :ign_geocoded_address, foreign_key: :geocoded_address

  def address_to_geocode
    "#{numero_et_voie}, #{code_postal} #{ville}, France"
  end
end
