# Require necessary gems
require "rubygems"
require "active_record"

# Establish connection to the database
require_relative "../database/databaseConnection"

# Define constants
TABLE_PROJECTS = :projects

# Create the 'projects' table
begin
  ActiveRecord::Base.connection.create_table TABLE_PROJECTS do |t|
    t.string :name
    t.text :description
    t.date :start_date
    t.date :deadline
    t.references :enterprise, foreign_key: true
  end
  puts "Table '#{TABLE_PROJECTS}' created with columns: title, description, start_date, end_date, enterprise_id."
rescue ActiveRecord::StatementInvalid
  puts "[create_table] Table '#{TABLE_PROJECTS}' already exists."
rescue ActiveRecord::ActiveRecordError => e
  puts "[create_table] Error occurred while creating table: #{e.message}"
end
