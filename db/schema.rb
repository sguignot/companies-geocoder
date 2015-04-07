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

ActiveRecord::Schema.define(version: 20150404205546) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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