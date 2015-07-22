namespace :fr_companies do
  desc 'Import french companies from CSV files'
  task :import, [:filenames] => :environment do |t, args|
    filenames = [args[:filenames]] + args.extras
    filenames.each do |filename|
      abs_path = File.absolute_path filename
      first_line = File.open(abs_path, 'r').gets
      column_names = first_line.strip.split(/ *, */).map(&:underscore)
      column_names_str = "\"#{column_names.join('","')}\""
      sql = "COPY fr_companies (#{column_names_str}) FROM #{FrCompany.sanitize abs_path} WITH CSV HEADER"
      puts "*** #{sql}"
      res = FrCompany.connection.execute sql
      puts "*** Successfully imported #{res.cmd_tuples} FR companies"
    end
      puts "*** Initializing created_at..."
      FrCompany.update_all(created_at: Time.now.utc)
      puts "*** DONE!"
  end

  desc 'Geocode french companies with Google Maps API'
  task :geocode_google => :environment do
    columns = [
      :id,
      :siret,
      :ville,
      :code_postal,
      :numero_et_voie
    ]
    FrCompany.select(columns).where(gmap_null_result: nil).each do |company|
      GeocodeGoogleFrCompaniesWorker.perform_async company.siret, company.address_to_geocode
    end
  end

  desc 'Geocode french companies with IGN Geoportail API'
  task :geocode_ign => :environment do
    # IGN API is buggy when the country 'France' is passed in free form address: wrong matches with Fort-de-France city
    FrCompany.where(ign_geocoded_address: nil).
      update_all("ign_geocoded_address = numero_et_voie || ' ' || code_postal || ' ' || ville")

    FrCompany.select(:ign_geocoded_address).
      joins('LEFT JOIN "ign_geocodes" ON "ign_geocodes"."geocoded_address" = "fr_companies"."ign_geocoded_address"').
      where(ign_geocodes: {id: nil}).
      where.not(ign_geocoded_address: nil).
      uniq.order(:ign_geocoded_address).each do |company|
      GeocodeIgnFrCompaniesWorker.perform_async(company.ign_geocoded_address)
    end
  end

  desc 'Export french companies in CSV format enriched with Google geocode'
  task :export, [:filename] => :environment do |t, args|
    abs_path = File.absolute_path args[:filename]
    columns = FrCompany.columns.map(&:name) - ['id','gmap_json']
    columns_str = columns.map do |column|
      "\"#{column}\" AS \"#{column.gsub('__','.')}\""
    end.join(',')

    sql = "COPY (SELECT #{columns_str} FROM fr_companies) TO #{FrCompany.sanitize abs_path} WITH CSV HEADER"
    puts "*** #{sql}"
    res = FrCompany.connection.execute sql
    puts "*** Successfully exported #{res.cmd_tuples} FR companies"
  end

end
