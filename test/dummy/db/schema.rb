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

ActiveRecord::Schema.define(version: 2020_08_01_231927) do

  create_table "fifths", force: :cascade do |t|
    t.string "name"
    t.integer "second_id"
    t.integer "fourth_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fourth_id"], name: "index_fifths_on_fourth_id"
    t.index ["second_id"], name: "index_fifths_on_second_id"
  end

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

  create_table "sixths", force: :cascade do |t|
    t.string "name"
    t.string "second_name"
    t.integer "second_number"
    t.integer "fifth_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["fifth_id"], name: "index_sixths_on_fifth_id"
  end

  create_table "thirds", force: :cascade do |t|
    t.string "rowid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "fifths", "fourths"
  add_foreign_key "fifths", "seconds"
  add_foreign_key "fourths", "firsts"
  add_foreign_key "seconds", "firsts"
  add_foreign_key "sixths", "fifths"
end
