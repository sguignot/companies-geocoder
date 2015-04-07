class UkCompany < ActiveRecord::Base
  def address_to_geocode
    res = ''
    res += reg_address__address_line1 if reg_address__address_line1?
    res += ", #{reg_address__address_line2}" if reg_address__address_line2?
    res += ", #{reg_address__post_town}" if reg_address__post_town?
    res += " #{reg_address__post_code}" if reg_address__post_code?
    # TODO: use CareOf, POBox, County, Country?
    # TODO: fix error 500 on DSTK when address contains a single quote
    res = res.strip.gsub("'", ' ')
    res
  end
end
