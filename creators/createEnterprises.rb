# Require necessary gems
require "rubygems"
require "active_record"

# Establish connection to the database
require_relative "../database/databaseConnection"

# Define constants
TABLE_ENTERPRISES = :enterprises

# Create the 'enterprises' table
begin
  ActiveRecord::Base.connection.create_table TABLE_ENTERPRISES do |t|
    t.string :name
    t.string :location
    t.float :revenue
    t.integer :established_year
  end
  puts "Table '#{TABLE_ENTERPRISES}' created with columns: name, location, revenue, established_year."
rescue ActiveRecord::StatementInvalid
  puts "[create_table] Table '#{TABLE_ENTERPRISES}' already exists."
rescue ActiveRecord::ActiveRecordError => e
  puts "[create_table] Error occurred while creating table: #{e.message}"
end
