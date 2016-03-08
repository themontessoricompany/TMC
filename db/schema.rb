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

ActiveRecord::Schema.define(version: 20160307091653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "order_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "quantity",   default: 0
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree
  add_index "line_items", ["product_id"], name: "index_line_items_on_product_id", using: :btree

  create_table "materials", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "materials_presentations", id: false, force: :cascade do |t|
    t.integer "presentation_id", null: false
    t.integer "material_id",     null: false
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "state",      default: 0
  end

  create_table "presentations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "topic_id"
    t.string   "summary"
    t.integer  "section",     default: 0
    t.string   "slug"
  end

  add_index "presentations", ["slug"], name: "index_presentations_on_slug", unique: true, using: :btree
  add_index "presentations", ["topic_id"], name: "index_presentations_on_topic_id", using: :btree

  create_table "presentations_products", id: false, force: :cascade do |t|
    t.integer "presentation_id", null: false
    t.integer "product_id",      null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "price"
  end

  create_table "products_presentations", id: false, force: :cascade do |t|
    t.integer "presentation_id", null: false
    t.integer "product_id",      null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "parent_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "slug"
  end

  add_index "topics", ["parent_id"], name: "index_topics_on_parent_id", using: :btree
  add_index "topics", ["slug"], name: "index_topics_on_slug", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "line_items", "orders"
  add_foreign_key "line_items", "products"
  add_foreign_key "presentations", "topics"
end
