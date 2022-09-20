# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_09_20_171656) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_uuid"
    t.string "status"
    t.string "cfdi_digital_stamp"
    t.string "currency"
    t.decimal "amount"
    t.datetime "emitted_at"
    t.datetime "expires_at"
    t.datetime "signed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "emitter_id"
    t.bigint "receiver_id"
    t.index ["amount"], name: "index_invoices_on_amount"
    t.index ["emitted_at"], name: "index_invoices_on_emitted_at"
    t.index ["emitter_id"], name: "index_invoices_on_emitter_id"
    t.index ["invoice_uuid"], name: "index_invoices_on_invoice_uuid"
    t.index ["receiver_id"], name: "index_invoices_on_receiver_id"
    t.index ["status"], name: "index_invoices_on_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest"
    t.string "tax_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "unique_emails", unique: true
    t.index ["tax_id"], name: "index_users_on_tax_id"
  end

  add_foreign_key "invoices", "users", column: "emitter_id"
  add_foreign_key "invoices", "users", column: "receiver_id"
end
