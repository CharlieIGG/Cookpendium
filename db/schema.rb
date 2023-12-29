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

ActiveRecord::Schema[7.0].define(version: 2023_12_29_184707) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredient_translations", force: :cascade do |t|
    t.bigint "ingredient_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["ingredient_id"], name: "index_ingredient_translations_on_ingredient_id"
    t.index ["locale"], name: "index_ingredient_translations_on_locale"
  end

  create_table "ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_step_translations", force: :cascade do |t|
    t.bigint "recipe_step_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "instruction"
    t.index ["locale"], name: "index_recipe_step_translations_on_locale"
    t.index ["recipe_step_id"], name: "index_recipe_step_translations_on_recipe_step_id"
  end

  create_table "recipe_steps", force: :cascade do |t|
    t.integer "step_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_translations", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.index ["locale"], name: "index_recipe_translations_on_locale"
    t.index ["recipe_id"], name: "index_recipe_translations_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
