class GeocodeUkCompaniesWorker
  include Sidekiq::Worker

  def perform(companies_addresses)
    company_numbers_by_address = {} # several companies may have the same address
    companies_addresses.each do |comp_addr|
      address = comp_addr['address_to_geocode']
      company_numbers_by_address[address] ||= []
      company_numbers_by_address[address] << comp_addr['company_number']
    end

    response = JSON.load RestClient.post(GEOCODING_DSTK_STREET2COORD_URL, company_numbers_by_address.keys.to_json,
      content_type: :json, accept: :json)

    updated_at = Time.now.utc
    response.each do |address, result|
      company_numbers = company_numbers_by_address[address]
      raise "cannot find back any company matching the geocoded address: #{address}" if company_numbers.nil? 
      if result.nil?
        UkCompany.where(company_number: company_numbers).update_all(
          dstk_geocoded_address: address,
          dstk_null_result: true,
          dstk_longitude: nil,
          dstk_latitude: nil,
          dstk_confidence: nil,
          dstk_street_address: nil,
          dstk_street_number: nil,
          dstk_street_name: nil,
          dstk_locality: nil,
          dstk_fips_county: nil,
          dstk_region: nil,
          dstk_country_code: nil,
          updated_at: updated_at
          )
      else
        UkCompany.where(company_number: company_numbers).update_all(
          dstk_geocoded_address: address,
          dstk_null_result: false,
          dstk_longitude: result['longitude'],
          dstk_latitude: result['latitude'],
          dstk_confidence: result['confidence'],
          dstk_street_address: result['street_address'],
          dstk_street_number: result['street_number'],
          dstk_street_name: result['street_name'],
          dstk_locality: result['locality'],
          dstk_fips_county: result['fips_county'],
          dstk_region: result['region'],
          dstk_country_code: result['country_code'],
          updated_at: updated_at
          )
      end
    end
  end

end
