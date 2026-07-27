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

ActiveRecord::Schema[8.1].define(version: 2026_07_27_013736) do
  create_table "entry_points", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "gear_option"
    t.string "guide_url"
    t.string "name"
    t.integer "position"
    t.datetime "updated_at", null: false
    t.index ["position"], name: "index_entry_points_on_position"
  end

  create_table "prep_missions", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.boolean "mandatory"
    t.string "name"
    t.integer "position"
    t.text "unlock_hint"
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_prep_missions_on_category"
    t.index ["mandatory"], name: "index_prep_missions_on_mandatory"
  end

  create_table "targets", force: :cascade do |t|
    t.integer "bag_weight"
    t.datetime "created_at", null: false
    t.integer "easy_first_alarm"
    t.integer "easy_first_no_alarm"
    t.integer "easy_repeat"
    t.integer "easy_repeat_alarm"
    t.integer "first_weekly_payout"
    t.integer "hard_first_alarm"
    t.integer "hard_first_no_alarm"
    t.integer "hard_repeat"
    t.integer "hard_repeat_alarm"
    t.string "kind"
    t.string "location"
    t.string "name"
    t.text "notes"
    t.integer "position"
    t.integer "repeat_payout"
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_targets_on_kind"
    t.index ["position"], name: "index_targets_on_position"
  end
end
