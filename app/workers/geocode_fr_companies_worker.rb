class GeocodeFrCompaniesWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 3

  def perform(siret, address)
    Proxy.with_proxy_lock do |proxy|
      elapsed_time_sec = Time.now.utc - proxy.last_query_at rescue 0
      sleep_time_sec = 1.2 - elapsed_time_sec
      if sleep_time_sec > 0
        logger.info "sleep #{sleep_time_sec} second(s)..."
        sleep sleep_time_sec
      end
      logger.info "using proxy #{proxy.url} to geocode address: #{address}"
      client = Faraday.new(proxy: proxy.url)
      res = client.get('http://maps.googleapis.com/maps/api/geocode/json',
        sensor: false,
        address: address
        )
      gmap_json = res.body
      response = JSON.load gmap_json

      if response['status'] == 'OK'
        result = response['results'].first
        street_number = nil
        locality = nil
        route = nil
        country_code = nil
        postal_code = nil
        result['address_components'].each do |c|
          if c['types'].include? 'street_number'
            street_number = c['long_name']
          elsif c['types'].include? 'locality'
            locality = c['long_name']
          elsif c['types'].include? 'route'
            route = c['long_name']
          elsif c['types'].include? 'country'
            country_code = c['short_name']
          elsif c['types'].include? 'postal_code'
            postal_code = c['long_name']
          end
        end
        FrCompany.find_by_siret(siret).update_attributes(
          gmap_geocoded_address: address,
          gmap_null_result: false,
          gmap_partial_match: (result['partial_match'] == true),
          gmap_longitude: result['geometry']['location']['lng'],
          gmap_latitude: result['geometry']['location']['lat'],
          gmap_location_type: result['geometry']['location_type'],
          gmap_street_number: street_number,
          gmap_locality: locality,
          gmap_route: route,
          gmap_country_code: country_code,
          gmap_postal_code: postal_code,
          gmap_formatted_address: result['formatted_address'],
          gmap_json: gmap_json
        )
      else
        if response['status'] == 'OVER_QUERY_LIMIT'
          raise Proxy::OverQueryLimitError.new "status: #{response['status']}: #{proxy.url}"
        else
          raise "status: #{response['status']}: #{proxy.url}"
        end
      end

    end
  end
end
