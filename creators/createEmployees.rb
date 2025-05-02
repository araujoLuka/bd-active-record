# Require necessary gems
require "rubygems"
require "active_record"

# Establish connection to the database
require_relative "../database/databaseConnection"

# Define constants
TABLE_EMPLOYEES = :employees

# Create the 'employees' table
begin
  ActiveRecord::Base.connection.create_table TABLE_EMPLOYEES do |t|
    t.string :name
    t.string :position
    t.float :salary
    t.integer :age
    t.references :enterprise, foreign_key: true
  end
  puts "Table '#{TABLE_EMPLOYEES}' created with columns: name, position, salary, age, enterprise_id."
rescue ActiveRecord::StatementInvalid
  puts "[create_table] Table '#{TABLE_EMPLOYEES}' already exists."
rescue ActiveRecord::ActiveRecordError => e
  puts "[create_table] Error occurred while creating table: #{e.message}"
end
