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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120701062617) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "tag"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "games", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "maximum_players"
    t.integer  "host_id"
    t.integer  "category_id"
    t.integer  "status_id",       :default => 1
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "games", ["category_id"], :name => "index_games_on_category_id"
  add_index "games", ["host_id"], :name => "index_games_on_host_id"
  add_index "games", ["maximum_players"], :name => "index_games_on_maximum_players"
  add_index "games", ["status_id"], :name => "index_games_on_status_id"
  add_index "games", ["title"], :name => "index_games_on_title", :unique => true

  create_table "posts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "posts", ["game_id", "user_id", "created_at"], :name => "index_posts_on_game_id_and_user_id_and_created_at"
  add_index "posts", ["user_id", "created_at"], :name => "index_posts_on_user_id_and_created_at"

  create_table "statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "statuses", ["name"], :name => "index_statuses_on_name"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "votes", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "votes", ["game_id"], :name => "index_votes_on_game_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
