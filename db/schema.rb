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

ActiveRecord::Schema.define(version: 2020_06_13_191012) do

  create_table "series", force: :cascade do |t|
    t.integer "id_serie"
    t.string "cover"
    t.string "name"
    t.string "categories"
    t.integer "chapters"
    t.text "description"
    t.string "artist"
    t.float "score"
    t.boolean "is_complete"
    t.string "lang"
    t.text "chapters_all"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["id_serie"], name: "index_series_on_id_serie"
    t.index ["name"], name: "index_series_on_name"
  end

end
