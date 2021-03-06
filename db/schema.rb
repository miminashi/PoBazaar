# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101005205603) do

  create_table "pos", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count"
    t.text     "header"
    t.binary   "file"
  end

  create_table "words", :force => true do |t|
    t.text     "msgid"
    t.text     "msgstr"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "place"
    t.text     "msgstrs"
    t.string   "name"
    t.integer  "poid"
    t.string   "msg_type"
    t.text     "msgid_plural"
  end

end
