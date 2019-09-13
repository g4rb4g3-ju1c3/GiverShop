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

ActiveRecord::Schema.define(version: 20161006021348) do

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,   null: false
    t.integer  "object_id",   limit: 4,   null: false
    t.integer  "object_type", limit: 4,   null: false
    t.string   "content",     limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "comments", ["user_id"], name: "fk_rails_03de2dc08c", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.text     "settings",    limit: 65535
    t.string   "description", limit: 255
    t.string   "lists",       limit: 255
    t.string   "notes",       limit: 255
    t.integer  "image_id",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.integer  "vendor_id",  limit: 4,                              null: false
    t.integer  "product_id", limit: 4,                              null: false
    t.string   "sku",        limit: 255
    t.integer  "quantity",   limit: 4
    t.decimal  "price",                    precision: 11, scale: 2
    t.string   "location",   limit: 255
    t.text     "notes",      limit: 65535
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "inventories", ["product_id"], name: "fk_rails_e94eb46135", using: :btree
  add_index "inventories", ["vendor_id", "product_id"], name: "index_inventories_on_vendor_id_and_product_id", unique: true, using: :btree

  create_table "items", force: :cascade do |t|
    t.integer  "list_id",     limit: 4,                     null: false
    t.integer  "product_id",  limit: 4
    t.string   "description", limit: 255
    t.integer  "position",    limit: 4
    t.integer  "priority",    limit: 4,     default: 50,    null: false
    t.boolean  "checked",                   default: false, null: false
    t.integer  "quantity",    limit: 4
    t.integer  "image_id",    limit: 4
    t.text     "notes",       limit: 65535
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "items", ["list_id"], name: "fk_rails_86a294a765", using: :btree
  add_index "items", ["product_id"], name: "fk_rails_9a56345cfd", using: :btree

  create_table "lists", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.string   "description", limit: 255
    t.integer  "image_id",    limit: 4
    t.text     "notes",       limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string   "title",       limit: 255,   null: false
    t.string   "description", limit: 255
    t.text     "content",     limit: 65535
    t.integer  "image_id",    limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "user_id",     limit: 4,   null: false
    t.integer  "object_id",   limit: 4,   null: false
    t.integer  "object_type", limit: 4,   null: false
    t.string   "permissions", limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "permissions", ["user_id", "object_id", "object_type"], name: "index_permissions_on_user_id_and_object_id_and_object_type", unique: true, using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "description", limit: 255,   null: false
    t.string   "size",        limit: 255
    t.string   "model",       limit: 255
    t.string   "upc",         limit: 255
    t.string   "origin",      limit: 255
    t.integer  "image_id",    limit: 4
    t.text     "notes",       limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "products", ["user_id"], name: "fk_rails_dee2631783", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255,   null: false
    t.string   "password_digest", limit: 255,   null: false
    t.text     "settings",        limit: 65535
    t.string   "name",            limit: 255
    t.string   "phone",           limit: 255
    t.string   "email",           limit: 255
    t.integer  "image_id",        limit: 4
    t.text     "notes",           limit: 65535
    t.string   "recent",          limit: 255
    t.datetime "last_login_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "vendors", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 255,   null: false
    t.text     "info",       limit: 65535
    t.integer  "image_id",   limit: 4
    t.text     "notes",      limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "vendors", ["user_id"], name: "fk_rails_827f84e5b7", using: :btree

  add_foreign_key "comments", "users"
  add_foreign_key "inventories", "products"
  add_foreign_key "inventories", "vendors"
  add_foreign_key "items", "lists"
  add_foreign_key "items", "products"
  add_foreign_key "permissions", "users"
  add_foreign_key "products", "users"
  add_foreign_key "vendors", "users"
end
