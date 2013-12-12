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

ActiveRecord::Schema.define(:version => 20131212172527) do

  create_table "friendships", :force => true do |t|
    t.integer  "inbound_friend_id",                    :null => false
    t.integer  "outbound_friend_id",                   :null => false
    t.boolean  "pending",            :default => true, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "friendships", ["inbound_friend_id", "outbound_friend_id"], :name => "index_friendships_on_inbound_friend_id_and_outbound_friend_id", :unique => true
  add_index "friendships", ["inbound_friend_id", "pending"], :name => "index_friendships_on_inbound_friend_id_and_pending"

  create_table "photos", :force => true do |t|
    t.string   "photo_file_file_name"
    t.string   "photo_file_content_type"
    t.integer  "photo_file_file_size"
    t.datetime "photo_file_updated_at"
    t.string   "{:null=>false}_file_name"
    t.string   "{:null=>false}_content_type"
    t.integer  "{:null=>false}_file_size"
    t.datetime "{:null=>false}_updated_at"
    t.integer  "user_id",                     :null => false
    t.string   "caption"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "photos", ["user_id"], :name => "index_photos_on_user_id"

  create_table "posts", :force => true do |t|
    t.integer  "author_id",    :null => false
    t.integer  "recipient_id", :null => false
    t.text     "body",         :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "posts", ["author_id", "recipient_id"], :name => "index_posts_on_author_id_and_recipient_id"
  add_index "posts", ["author_id"], :name => "index_posts_on_author_id"
  add_index "posts", ["recipient_id"], :name => "index_posts_on_recipient_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                      :null => false
    t.string   "password_digest",            :null => false
    t.string   "session_token",              :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "profile_photo_file_name"
    t.string   "profile_photo_content_type"
    t.integer  "profile_photo_file_size"
    t.datetime "profile_photo_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["session_token"], :name => "index_users_on_session_token"

end
