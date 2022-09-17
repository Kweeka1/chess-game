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

ActiveRecord::Schema[7.0].define(version: 2022_09_17_080544) do
  create_table "chess_boards", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "row_1"
    t.string "row_2"
    t.string "row_3"
    t.string "row_4"
    t.string "row_5"
    t.string "row_6"
    t.string "row_7"
    t.string "row_8"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "room_id"
    t.bigint "temporary_room_id"
    t.index ["room_id"], name: "index_chess_boards_on_room_id"
    t.index ["temporary_room_id"], name: "index_chess_boards_on_temporary_room_id"
  end

  create_table "rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "room_id", null: false
    t.string "room_name", null: false
    t.string "room_description"
    t.string "room_password"
    t.string "room_opponent", null: false
    t.string "room_allow_viewers"
    t.string "room_privacy"
    t.string "room_only_players_chat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["room_id"], name: "index_rooms_on_room_id", unique: true
    t.index ["room_name"], name: "index_rooms_on_room_name", unique: true
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "temporary_rooms", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "room_id", null: false
    t.string "room_name", null: false
    t.string "room_host", null: false
    t.string "room_description"
    t.string "room_password"
    t.string "room_opponent", null: false
    t.string "room_allow_viewers"
    t.string "room_privacy"
    t.string "room_only_players_chat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_temporary_rooms_on_room_id", unique: true
    t.index ["room_name"], name: "index_temporary_rooms_on_room_name", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user"], name: "index_users_on_user", unique: true
  end

  add_foreign_key "chess_boards", "rooms"
  add_foreign_key "chess_boards", "temporary_rooms"
  add_foreign_key "rooms", "users"
end
