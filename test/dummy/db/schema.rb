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

ActiveRecord::Schema.define(version: 2020_03_17_130019) do

  create_table "firsts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fourths", force: :cascade do |t|
    t.string "name"
    t.integer "first_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.index ["first_id"], name: "index_fourths_on_first_id"
  end

  create_table "seconds", force: :cascade do |t|
    t.integer "first_id"
    t.string "name"
    t.date "date"
    t.integer "number"
    t.boolean "boolean"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_id"], name: "index_seconds_on_first_id"
  end

  create_table "thirds", force: :cascade do |t|
    t.string "rowid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "fourths", "firsts"
  add_foreign_key "seconds", "firsts"
end
