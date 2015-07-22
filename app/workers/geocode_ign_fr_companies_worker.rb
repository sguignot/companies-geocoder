IGN_KEY = ENV['IGN_KEY'] || raise('Missing env var: IGN_KEY')

class GeocodeIgnFrCompaniesWorker
  include Sidekiq::Worker

  def perform(address)
    # sleep_time_sec = 1.2
    # logger.info "sleep #{sleep_time_sec} second(s)..."
    # sleep sleep_time_sec

    req_builder = Nokogiri::XML::Builder.new do |xml|
      xml.XLS(
        'xmlns:gml'          => 'http://www.opengis.net/gml',
        'xmlns'              => 'http://www.opengis.net/xls',
        'xmlns:xsi'          => 'http://www.w3.org/2001/XMLSchema-instance',
        'version'            => '1.2',
        'xsi:schemaLocation' => 'http://www.opengis.net/xls http://schemas.opengis.net/ols/1.2/olsAll.xsd'
        ) do
        xml.RequestHeader(srsName: 'epsg:4326')
        xml.Request(maximumResponses: '25', methodName: 'GeocodeRequest', requestID: 'uid42', version: '1.2') do
          xml.GeocodeRequest(returnFreeForm: 'false') do
            xml.Address(countryCode: 'StreetAddress') do
              xml.freeFormAddress address
            end
          end
        end
      end
    end
    req_xml = req_builder.to_xml(indent: 0, encoding: 'UTF-8')

    client = Faraday.new
    res = client.post do |req|
      req.url "http://gpp3-wxs.ign.fr/#{IGN_KEY}/geoportail/ols"
      req.headers['Content-Type'] = 'text/xml'
      req.headers['User-Agent'] = 'iOS' # IGN "security header"
      req.body = req_xml
    end

    ign_xml = res.body
    xml = Nokogiri::XML(ign_xml)
    xml.remove_namespaces!
    if xml.at_xpath('/ExceptionReport')
      raise ign_xml
    end
    list = xml.at_xpath('/XLS/Response/GeocodeResponse/GeocodeResponseList')
    n_results = list.attr('numberOfGeocodedAddresses').to_i rescue 0
    ga = list.at_xpath('./GeocodedAddress')
    if ga
      pos = ga.at_xpath('./Point/pos').try(:content)
      lat, lon = pos.split if pos
      a = ga.at_xpath('./Address')
      if a
        sa = a.at_xpath('./StreetAddress')
        building_num = sa.at_xpath('./Building').attr('number') rescue nil
        street = sa.at_xpath('./Street').try(:content) rescue nil
        municipality = a.at_xpath('Place[@type="Municipality"]').try(:content)
        qualite = a.at_xpath('Place[@type="Qualite"]').try(:content)
        departement = a.at_xpath('Place[@type="Departement"]').try(:content)
        bbox = a.at_xpath('Place[@type="Bbox"]').try(:content)
        commune = a.at_xpath('Place[@type="Commune"]').try(:content)
        insee = a.at_xpath('Place[@type="INSEE"]').try(:content)
        territoire = a.at_xpath('Place[@type="Territoire"]').try(:content)
        id_ign = a.at_xpath('Place[@type="ID"]').try(:content)
        id_tr = a.at_xpath('Place[@type="ID_TR"]').try(:content)
        postal_code = a.at_xpath('PostalCode').try(:content)
      end
      match_accuracy = ga.at_xpath('./GeocodeMatchCode').attr('accuracy') rescue nil
      match_type = ga.at_xpath('./GeocodeMatchCode').attr('matchType') rescue nil

      IgnGeocode.create!(
        geocoded_address: address,
        n_results: n_results,
        pos: pos,
        latitude: lat,
        longitude: lon,
        building_number: building_num,
        street: street,
        municipality: municipality,
        qualite: qualite,
        departement: departement,
        bbox: bbox,
        commune: commune,
        insee: insee,
        territoire: territoire,
        id_ign: id_ign,
        id_tr: id_tr,
        postal_code: postal_code,
        match_accuracy: match_accuracy,
        match_type: match_type,
        ign_xml: ign_xml
      )
    else
      # no result
      IgnGeocode.create!(
        geocoded_address: address,
        n_results: n_results,
        ign_xml: ign_xml
      )
    end

  end
end
