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

ActiveRecord::Schema.define(version: 20200317190910) do

  create_table "employees", force: :cascade do |t|
    t.string "Badge_"
    t.string "Firstname"
    t.string "Lastname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fs_order_parts", force: :cascade do |t|
    t.integer "fs_order_id"
    t.string "partcode"
    t.integer "qty"
    t.string "partdesc"
    t.string "uom"
    t.boolean "new_part"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "back_order"
  end

  create_table "fs_orders", force: :cascade do |t|
    t.string "customer"
    t.string "shipto"
    t.date "date_required"
    t.string "rep"
    t.string "status"
    t.string "cancel_rep"
    t.date "cancel_date"
    t.string "po_number"
    t.text "notes"
    t.boolean "order_entered"
    t.boolean "second_run"
    t.string "order_num"
    t.boolean "in_process"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dp"
    t.string "rep_name"
    t.string "reject_reason"
    t.string "cut_off"
  end

  create_table "lateorderscustomercos", force: :cascade do |t|
    t.string "cust_code"
    t.string "shipto_code"
    t.string "route_code"
    t.datetime "cutoff_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "retail_order_parts", force: :cascade do |t|
    t.integer "retail_order_id"
    t.string "partcode"
    t.integer "qty"
    t.string "partdesc"
    t.string "uom"
    t.boolean "new_part"
    t.boolean "back_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "retail_orders", force: :cascade do |t|
    t.string "customer"
    t.string "shipto"
    t.date "date_required"
    t.string "rep"
    t.string "status"
    t.string "cancel_rep"
    t.date "cancel_date"
    t.string "po_number"
    t.text "notes"
    t.boolean "order_entered"
    t.boolean "second_run"
    t.string "order_num"
    t.boolean "in_process"
    t.string "dp"
    t.string "rep_name"
    t.string "reject_reason"
    t.string "cut_off"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "retail_rapid_order"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
