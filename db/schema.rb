# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150606225204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fr_companies", force: :cascade do |t|
    t.text     "siret",                  null: false
    t.text     "ville"
    t.text     "code_postal"
    t.text     "numero_et_voie"
    t.text     "gmap_geocoded_address"
    t.boolean  "gmap_null_result"
    t.boolean  "gmap_partial_match"
    t.text     "gmap_longitude"
    t.text     "gmap_latitude"
    t.text     "gmap_location_type"
    t.text     "gmap_street_number"
    t.text     "gmap_locality"
    t.text     "gmap_route"
    t.text     "gmap_country_code"
    t.text     "gmap_postal_code"
    t.text     "gmap_formatted_address"
    t.text     "gmap_json"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fr_companies", ["code_postal"], name: "index_fr_companies_on_code_postal", using: :btree
  add_index "fr_companies", ["gmap_location_type"], name: "index_fr_companies_on_gmap_location_type", using: :btree
  add_index "fr_companies", ["gmap_null_result"], name: "index_fr_companies_on_gmap_null_result", using: :btree
  add_index "fr_companies", ["gmap_partial_match"], name: "index_fr_companies_on_gmap_partial_match", using: :btree
  add_index "fr_companies", ["siret"], name: "index_fr_companies_on_siret", unique: true, using: :btree

  create_table "proxies", force: :cascade do |t|
    t.string   "url"
    t.datetime "last_query_at"
    t.datetime "daily_quota_hit_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "proxies", ["daily_quota_hit_at"], name: "index_proxies_on_daily_quota_hit_at", using: :btree
  add_index "proxies", ["last_query_at"], name: "index_proxies_on_last_query_at", using: :btree
  add_index "proxies", ["url"], name: "index_proxies_on_url", unique: true, using: :btree

  create_table "uk_companies", force: :cascade do |t|
    t.string   "company_name",                           null: false
    t.string   "company_number",                         null: false
    t.string   "reg_address__care_of"
    t.string   "reg_address__po_box"
    t.string   "reg_address__address_line1"
    t.string   "reg_address__address_line2"
    t.string   "reg_address__post_town"
    t.string   "reg_address__county"
    t.string   "reg_address__country"
    t.string   "reg_address__post_code"
    t.string   "company_category"
    t.string   "company_status"
    t.string   "country_of_origin"
    t.string   "dissolution_date"
    t.string   "incorporation_date"
    t.string   "accounts__account_ref_day"
    t.string   "accounts__account_ref_month"
    t.string   "accounts__next_due_date"
    t.string   "accounts__last_made_up_date"
    t.string   "accounts__account_category"
    t.string   "returns__next_due_date"
    t.string   "returns__last_made_up_date"
    t.string   "mortgages__num_mort_charges"
    t.string   "mortgages__num_mort_outstanding"
    t.string   "mortgages__num_mort_part_satisfied"
    t.string   "mortgages__num_mort_satisfied"
    t.string   "sic_code__sic_text_1"
    t.string   "sic_code__sic_text_2"
    t.string   "sic_code__sic_text_3"
    t.string   "sic_code__sic_text_4"
    t.string   "limited_partnerships__num_gen_partners"
    t.string   "limited_partnerships__num_lim_partners"
    t.string   "uri"
    t.string   "previous_name_1__condate"
    t.string   "previous_name_1__company_name"
    t.string   "previous_name_2__condate"
    t.string   "previous_name_2__company_name"
    t.string   "previous_name_3__condate"
    t.string   "previous_name_3__company_name"
    t.string   "previous_name_4__condate"
    t.string   "previous_name_4__company_name"
    t.string   "previous_name_5__condate"
    t.string   "previous_name_5__company_name"
    t.string   "previous_name_6__condate"
    t.string   "previous_name_6__company_name"
    t.string   "previous_name_7__condate"
    t.string   "previous_name_7__company_name"
    t.string   "previous_name_8__condate"
    t.string   "previous_name_8__company_name"
    t.string   "previous_name_9__condate"
    t.string   "previous_name_9__company_name"
    t.string   "previous_name_10__condate"
    t.string   "previous_name_10__company_name"
    t.text     "dstk_geocoded_address"
    t.boolean  "dstk_null_result"
    t.string   "dstk_longitude"
    t.string   "dstk_latitude"
    t.integer  "dstk_confidence"
    t.string   "dstk_street_address"
    t.string   "dstk_street_number"
    t.string   "dstk_street_name"
    t.string   "dstk_locality"
    t.string   "dstk_fips_county"
    t.string   "dstk_region"
    t.string   "dstk_country_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uk_companies", ["company_number"], name: "index_uk_companies_on_company_number", unique: true, using: :btree
  add_index "uk_companies", ["dstk_null_result"], name: "index_uk_companies_on_dstk_null_result", using: :btree
  add_index "uk_companies", ["reg_address__post_code"], name: "index_uk_companies_on_reg_address__post_code", using: :btree

end
