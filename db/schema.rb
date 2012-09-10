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

ActiveRecord::Schema.define(:version => 20120909080518) do

  create_table "games", :force => true do |t|
    t.string   "title"
    t.integer  "player_cap"
    t.integer  "host_id"
    t.boolean  "mini"
    t.boolean  "invite"
    t.string   "category"
    t.integer  "status_id",  :default => 1
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "games", ["host_id"], :name => "index_games_on_host_id"
  add_index "games", ["status_id"], :name => "index_games_on_status_id"
  add_index "games", ["updated_at"], :name => "index_games_on_updated_at"

  create_table "posts", :force => true do |t|
    t.text     "content"
    t.integer  "owner_id"
    t.integer  "game_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "posts", ["created_at"], :name => "index_posts_on_created_at"
  add_index "posts", ["game_id"], :name => "index_posts_on_game_id"
  add_index "posts", ["owner_id"], :name => "index_posts_on_owner_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",                  :default => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "approved",               :default => false
    t.boolean  "host_privileges",        :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "votes", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.boolean  "approved",   :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "votes", ["game_id"], :name => "index_votes_on_game_id"
  add_index "votes", ["user_id"], :name => "index_votes_on_user_id"

end
