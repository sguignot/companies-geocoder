namespace :uk_basicdata do
  desc 'Import companies from UK Basic Data CSV files'
  task :import, [:filenames] => :environment do |t, args|
    filenames = [args[:filenames]] + args.extras
    filenames.each do |filename|
      abs_path = File.absolute_path filename
      first_line = File.open(abs_path, 'r').gets
      column_names = first_line.strip.gsub('.','__').split(/ *, */).map(&:underscore) # replace '.' chars with '__' to get valid columns
      column_names_str = "\"#{column_names.join('","')}\""
      sql = "COPY uk_companies (#{column_names_str}) FROM #{UkCompany.sanitize abs_path} WITH CSV HEADER"
      puts "*** #{sql}"
      res = UkCompany.connection.execute sql
      puts "*** Successfully imported #{res.cmd_tuples} UK companies"
    end
      puts "*** Initializing created_at..."
      UkCompany.update_all(created_at: Time.now.utc)
      puts "*** DONE!"
  end

  desc 'Geocode companies from UK Basic Data'
  task :geocode => :environment do
    columns = [
      :id,
      :company_number,
      :reg_address__address_line1,
      :reg_address__address_line2,
      :reg_address__post_town,
      :reg_address__county,
      :reg_address__country,
      :reg_address__post_code
    ]
    UkCompany.select(columns).
    where(dstk_null_result: nil).
    order(:reg_address__post_code).
    find_in_batches(batch_size: GEOCODING_BATCH_SIZE) do |group|
      companies_addresses = group.map do |company|
        { company_number: company.company_number, address_to_geocode: company.address_to_geocode }
      end
      GeocodeUkCompaniesWorker.perform_async companies_addresses
    end
  end

  desc 'Export UK companies in UK Basic Data CSV format enriched with geocode'
  task :export, [:filename] => :environment do |t, args|
    abs_path = File.absolute_path args[:filename]
    columns = UkCompany.columns.map(&:name) - ['id']
    columns_str = columns.map do |column|
      "\"#{column}\" AS \"#{column.gsub('__','.')}\""
    end.join(',')

    sql = "COPY (SELECT #{columns_str} FROM uk_companies) TO #{UkCompany.sanitize abs_path} WITH CSV HEADER"
    puts "*** #{sql}"
    res = UkCompany.connection.execute sql
    puts "*** Successfully exported #{res.cmd_tuples} UK companies"
  end

end
