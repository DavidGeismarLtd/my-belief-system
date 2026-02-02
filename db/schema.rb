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

ActiveRecord::Schema[8.1].define(version: 2026_02_02_110742) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "actor_value_portraits", force: :cascade do |t|
    t.bigint "actor_id", null: false
    t.decimal "confidence", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.decimal "intensity", precision: 5, scale: 2
    t.decimal "position", precision: 5, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.bigint "value_dimension_id", null: false
    t.index ["actor_id", "value_dimension_id"], name: "index_actor_portraits_on_actor_and_dimension", unique: true
    t.index ["actor_id"], name: "index_actor_value_portraits_on_actor_id"
    t.index ["position"], name: "index_actor_value_portraits_on_position"
    t.index ["value_dimension_id"], name: "index_actor_value_portraits_on_value_dimension_id"
  end

  create_table "actors", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "actor_type", null: false
    t.string "country", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "image_url"
    t.jsonb "metadata", default: {}
    t.string "name", null: false
    t.string "party_affiliation"
    t.string "program_url"
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_actors_on_active"
    t.index ["actor_type"], name: "index_actors_on_actor_type"
    t.index ["country", "actor_type", "active"], name: "index_actors_on_country_type_active"
    t.index ["country"], name: "index_actors_on_country"
    t.index ["name"], name: "index_actors_on_name"
  end

  create_table "interventions", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.bigint "actor_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.string "intervention_type", null: false
    t.jsonb "metadata", default: {}
    t.datetime "published_at"
    t.string "source_platform"
    t.string "source_url"
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_interventions_on_active"
    t.index ["actor_id", "published_at"], name: "index_interventions_on_actor_and_published"
    t.index ["actor_id"], name: "index_interventions_on_actor_id"
    t.index ["intervention_type"], name: "index_interventions_on_intervention_type"
    t.index ["published_at"], name: "index_interventions_on_published_at"
  end

  create_table "questions", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "country"
    t.datetime "created_at", null: false
    t.integer "difficulty_score", default: 1
    t.boolean "is_universal", default: false, null: false
    t.jsonb "options", default: {}
    t.integer "position", default: 0, null: false
    t.string "question_type", null: false
    t.text "text", null: false
    t.datetime "updated_at", null: false
    t.bigint "value_dimension_id", null: false
    t.index ["active"], name: "index_questions_on_active"
    t.index ["country", "active", "position"], name: "index_questions_on_country_active_position"
    t.index ["country"], name: "index_questions_on_country"
    t.index ["is_universal"], name: "index_questions_on_is_universal"
    t.index ["position"], name: "index_questions_on_position"
    t.index ["question_type"], name: "index_questions_on_question_type"
    t.index ["value_dimension_id", "position"], name: "index_questions_on_value_dimension_id_and_position"
    t.index ["value_dimension_id"], name: "index_questions_on_value_dimension_id"
  end

  create_table "user_answers", force: :cascade do |t|
    t.jsonb "answer_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.bigint "question_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["answer_data"], name: "index_user_answers_on_answer_data", using: :gin
    t.index ["created_at"], name: "index_user_answers_on_created_at"
    t.index ["question_id"], name: "index_user_answers_on_question_id"
    t.index ["user_id", "question_id"], name: "index_user_answers_on_user_id_and_question_id", unique: true
    t.index ["user_id"], name: "index_user_answers_on_user_id"
  end

  create_table "user_value_portraits", force: :cascade do |t|
    t.decimal "confidence", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.decimal "intensity", precision: 5, scale: 2
    t.decimal "position", precision: 5, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "value_dimension_id", null: false
    t.index ["position"], name: "index_user_value_portraits_on_position"
    t.index ["user_id", "value_dimension_id"], name: "index_user_portraits_on_user_and_dimension", unique: true
    t.index ["user_id"], name: "index_user_value_portraits_on_user_id"
    t.index ["value_dimension_id"], name: "index_user_value_portraits_on_value_dimension_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "age"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "gender"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "name"
    t.boolean "onboarding_completed", default: false, null: false
    t.integer "onboarding_progress", default: 0, null: false
    t.string "political_engagement"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.jsonb "skipped_questions", default: []
    t.datetime "updated_at", null: false
    t.index ["country"], name: "index_users_on_country"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["onboarding_completed"], name: "index_users_on_onboarding_completed"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "value_dimensions", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.text "left_description"
    t.string "left_pole", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.text "right_description"
    t.string "right_pole", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_value_dimensions_on_active"
    t.index ["key"], name: "index_value_dimensions_on_key", unique: true
    t.index ["position"], name: "index_value_dimensions_on_position"
  end

  add_foreign_key "actor_value_portraits", "actors"
  add_foreign_key "actor_value_portraits", "value_dimensions"
  add_foreign_key "interventions", "actors"
  add_foreign_key "questions", "value_dimensions"
  add_foreign_key "user_answers", "questions"
  add_foreign_key "user_answers", "users"
  add_foreign_key "user_value_portraits", "users"
  add_foreign_key "user_value_portraits", "value_dimensions"
end
