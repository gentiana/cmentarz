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

ActiveRecord::Schema.define(version: 20_140_801_130_943) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'birth_dates', force: true do |t|
    t.integer 'person_id'
    t.integer 'year'
    t.integer 'month'
    t.integer 'day'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'birth_dates', ['person_id'], name: 'index_birth_dates_on_person_id', using: :btree

  create_table 'death_dates', force: true do |t|
    t.integer 'person_id'
    t.integer 'year'
    t.integer 'month'
    t.integer 'day'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'death_dates', ['person_id'], name: 'index_death_dates_on_person_id', using: :btree

  create_table 'graves', force: true do |t|
    t.integer 'quarter_id'
    t.integer 'grave_type'
    t.string 'number'
    t.text 'description'
    t.string 'family_name'
    t.integer 'data_state', default: 1
    t.text 'notes'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  create_table 'people', force: true do |t|
    t.integer 'grave_id'
    t.string 'first_name'
    t.string 'last_name'
    t.string 'family_name'
    t.text 'description'
    t.integer 'lived'
    t.string 'raw_record'
    t.integer 'data_state', default: 1
    t.text 'notes'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end

  add_index 'people', ['grave_id'], name: 'index_people_on_grave_id', using: :btree
  add_index 'people', ['last_name'], name: 'index_people_on_last_name', using: :btree

  create_table 'quarters', force: true do |t|
    t.string 'name'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'short_name'
  end
end
