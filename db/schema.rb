# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_30_211444) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  create_table "_hcmeta", id: :serial, force: :cascade do |t|
    t.integer "hcver"
    t.string "org_id", limit: 50
    t.text "details"
  end

  create_table "_sf_event_log", id: :serial, force: :cascade do |t|
    t.string "table_name", limit: 128
    t.string "action", limit: 7
    t.datetime "synced_at", default: -> { "now()" }
    t.datetime "sf_timestamp"
    t.string "sfid", limit: 20
    t.text "record"
    t.boolean "processed"
    t.index ["sfid"], name: "idx__sf_event_log_sfid"
    t.index ["table_name", "synced_at"], name: "idx__sf_event_log_comp_key"
  end

  create_table "_trigger_log", id: :serial, force: :cascade do |t|
    t.bigint "txid"
    t.datetime "created_at", default: -> { "now()" }
    t.datetime "updated_at", default: -> { "now()" }
    t.datetime "processed_at"
    t.bigint "processed_tx"
    t.string "state", limit: 8
    t.string "action", limit: 7
    t.string "table_name", limit: 128
    t.integer "record_id"
    t.string "sfid", limit: 18
    t.text "old"
    t.text "values"
    t.integer "sf_result"
    t.text "sf_message"
    t.index ["created_at"], name: "_trigger_log_idx_created_at"
    t.index ["state", "id"], name: "_trigger_log_idx_state_id"
    t.index ["state", "table_name"], name: "_trigger_log_idx_state_table_name", where: "(((state)::text = 'NEW'::text) OR ((state)::text = 'PENDING'::text))"
  end

  create_table "_trigger_log_archive", id: :integer, default: nil, force: :cascade do |t|
    t.bigint "txid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "processed_at"
    t.bigint "processed_tx"
    t.string "state", limit: 8
    t.string "action", limit: 7
    t.string "table_name", limit: 128
    t.integer "record_id"
    t.string "sfid", limit: 18
    t.text "old"
    t.text "values"
    t.integer "sf_result"
    t.text "sf_message"
    t.index ["created_at"], name: "_trigger_log_archive_idx_created_at"
    t.index ["record_id"], name: "_trigger_log_archive_idx_record_id"
    t.index ["state", "table_name"], name: "_trigger_log_archive_idx_state_table_name", where: "((state)::text = 'FAILED'::text)"
  end

  create_table "contact", id: :serial, force: :cascade do |t|
    t.datetime "createddate"
    t.boolean "isdeleted"
    t.string "name", limit: 121
    t.datetime "systemmodstamp"
    t.string "email", limit: 80
    t.string "lastname", limit: 80
    t.string "sfid", limit: 18
    t.string "_hc_lastop", limit: 32
    t.text "_hc_err"
    t.float "customersatisfaction__c"
    t.string "phone", limit: 40
    t.uuid "heroku_uuid"
    t.index ["sfid"], name: "hcu_idx_contact_sfid", unique: true
    t.index ["systemmodstamp"], name: "hc_idx_contact_systemmodstamp"
  end

  create_table "customer_feedbacks", force: :cascade do |t|
    t.string "rating"
    t.string "description"
    t.string "location"
    t.integer "recommendation"
    t.text "suggestion"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sms_responses", force: :cascade do |t|
    t.string "phone_number"
    t.string "question"
    t.string "response_timestamp"
    t.string "response_choice"
    t.string "response_answer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.string "question_id"
    t.string "answer_type"
    t.string "answer"
    t.string "field"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "object"
    t.integer "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
