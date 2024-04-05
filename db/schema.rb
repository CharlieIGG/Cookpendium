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

ActiveRecord::Schema[7.1].define(version: 2024_04_05_195644) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "grocery_section_translations", force: :cascade do |t|
    t.bigint "grocery_section_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.index ["grocery_section_id"], name: "index_grocery_section_translations_on_grocery_section_id"
    t.index ["locale"], name: "index_grocery_section_translations_on_locale"
  end

  create_table "grocery_sections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.bigint "grocery_section_id"
    t.index ["grocery_section_id"], name: "index_ingredients_on_grocery_section_id"
  end

  create_table "measurement_unit_translations", force: :cascade do |t|
    t.bigint "measurement_unit_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "abbreviation"
    t.index ["locale"], name: "index_measurement_unit_translations_on_locale"
    t.index ["measurement_unit_id"], name: "index_measurement_unit_translations_on_measurement_unit_id"
  end

  create_table "measurement_units", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.float "quantity"
    t.bigint "ingredient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "measurement_unit_id"
    t.index ["ingredient_id"], name: "index_recipe_ingredients_on_ingredient_id"
    t.index ["measurement_unit_id"], name: "index_recipe_ingredients_on_measurement_unit_id"
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipe_step_ingredients", force: :cascade do |t|
    t.bigint "recipe_step_id", null: false
    t.float "quantity"
    t.bigint "ingredient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "measurement_unit_id"
    t.index ["ingredient_id"], name: "index_recipe_step_ingredients_on_ingredient_id"
    t.index ["measurement_unit_id"], name: "index_recipe_step_ingredients_on_measurement_unit_id"
    t.index ["recipe_step_id"], name: "index_recipe_step_ingredients_on_recipe_step_id"
  end

  create_table "recipe_step_translations", force: :cascade do |t|
    t.bigint "recipe_step_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "instruction"
    t.text "description", null: false
    t.index ["locale"], name: "index_recipe_step_translations_on_locale"
    t.index ["recipe_step_id"], name: "index_recipe_step_translations_on_recipe_step_id"
  end

  create_table "recipe_steps", force: :cascade do |t|
    t.integer "step_number"
    t.bigint "recipe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_recipe_steps_on_recipe_id"
  end

  create_table "recipe_translations", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.string "serving_unit"
    t.index ["locale"], name: "index_recipe_translations_on_locale"
    t.index ["recipe_id"], name: "index_recipe_translations_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "servings"
    t.boolean "vegetarian"
    t.boolean "vegan"
    t.integer "cooking_time_minutes"
    t.integer "prep_time_minutes"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ai_usage_this_week", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ingredients", "grocery_sections"
  add_foreign_key "recipe_ingredients", "ingredients"
  add_foreign_key "recipe_ingredients", "measurement_units"
  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipe_step_ingredients", "ingredients"
  add_foreign_key "recipe_step_ingredients", "measurement_units"
  add_foreign_key "recipe_step_ingredients", "recipe_steps"
  add_foreign_key "recipe_steps", "recipes"
end
