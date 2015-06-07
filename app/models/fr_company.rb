class FrCompany < ActiveRecord::Base
  def address_to_geocode
    "#{numero_et_voie}, #{code_postal} #{ville}, France"
  end
end
