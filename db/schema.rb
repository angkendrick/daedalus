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

ActiveRecord::Schema.define(version: 20150725225534) do

  create_table "highscores", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "name"
    t.integer  "highscore"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "maps", force: :cascade do |t|
    t.string  "level"
    t.integer "number"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "position"
    t.integer  "level_number"
    t.string   "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.integer  "times_played"
    t.time     "total_time"
    t.time     "last_time_stamp"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
  end

  create_table "save_states", force: :cascade do |t|
    t.integer  "player_id"
    t.string   "map"
    t.integer  "score"
    t.integer  "keys"
    t.integer  "gems"
    t.integer  "coins"
    t.boolean  "done"
    t.integer  "steps"
    t.string   "player_position"
    t.integer  "current_level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
