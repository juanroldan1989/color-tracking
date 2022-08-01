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

ActiveRecord::Schema[7.0].define(version: 2022_07_26_231431) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_colors", force: :cascade do |t|
    t.string "api_key", null: false
    t.integer "action_id", null: false
    t.integer "color_id", null: false
    t.integer "amount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_id"], name: "index_action_colors_on_action_id"
    t.index ["amount"], name: "index_action_colors_on_amount"
    t.index ["api_key"], name: "index_action_colors_on_api_key"
    t.index ["color_id"], name: "index_action_colors_on_color_id"
  end

  create_table "actions", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_actions_on_name"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_colors_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_users_on_api_key"
  end

end
