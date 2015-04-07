class CreateUkCompanies < ActiveRecord::Migration
  def change
    create_table :uk_companies do |t|
      t.string :company_name, null: false
      t.string :company_number, null: false
      [
        :RegAddress__CareOf,
        :RegAddress__POBox,
        :RegAddress__AddressLine1,
        :RegAddress__AddressLine2,
        :RegAddress__PostTown,
        :RegAddress__County,
        :RegAddress__Country,
        :RegAddress__PostCode,
        :CompanyCategory,
        :CompanyStatus,
        :CountryOfOrigin,
        :DissolutionDate,
        :IncorporationDate,
        :Accounts__AccountRefDay,
        :Accounts__AccountRefMonth,
        :Accounts__NextDueDate,
        :Accounts__LastMadeUpDate,
        :Accounts__AccountCategory,
        :Returns__NextDueDate,
        :Returns__LastMadeUpDate,
        :Mortgages__NumMortCharges,
        :Mortgages__NumMortOutstanding,
        :Mortgages__NumMortPartSatisfied,
        :Mortgages__NumMortSatisfied,
        :SICCode__SicText_1,
        :SICCode__SicText_2,
        :SICCode__SicText_3,
        :SICCode__SicText_4,
        :LimitedPartnerships__NumGenPartners,
        :LimitedPartnerships__NumLimPartners,
        :URI,
        :PreviousName_1__CONDATE,
        :PreviousName_1__CompanyName,
        :PreviousName_2__CONDATE,
        :PreviousName_2__CompanyName,
        :PreviousName_3__CONDATE,
        :PreviousName_3__CompanyName,
        :PreviousName_4__CONDATE,
        :PreviousName_4__CompanyName,
        :PreviousName_5__CONDATE,
        :PreviousName_5__CompanyName,
        :PreviousName_6__CONDATE,
        :PreviousName_6__CompanyName,
        :PreviousName_7__CONDATE,
        :PreviousName_7__CompanyName,
        :PreviousName_8__CONDATE,
        :PreviousName_8__CompanyName,
        :PreviousName_9__CONDATE,
        :PreviousName_9__CompanyName,
        :PreviousName_10__CONDATE,
        :PreviousName_10__CompanyName
      ].each do |col|
        t.string col.to_s.underscore
      end
      t.text :dstk_geocoded_address
      t.boolean :dstk_null_result
      t.string :dstk_longitude
      t.string :dstk_latitude
      t.integer :dstk_confidence
      t.string :dstk_street_address
      t.string :dstk_street_number
      t.string :dstk_street_name
      t.string :dstk_locality
      t.string :dstk_fips_county
      t.string :dstk_region
      t.string :dstk_country_code
      t.timestamps null: true
    end
    add_index :uk_companies, :company_number, unique: true
    add_index :uk_companies, :reg_address__post_code
    add_index :uk_companies, :dstk_null_result
  end
end
