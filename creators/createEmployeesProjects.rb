# Require necessary gems
require "rubygems"
require "active_record"

# Establish connection to the database
require_relative "../database/databaseConnection"

# Define constants
TABLE_EMPLOYEES_PROJECTS = :employees_projects

# Create the 'employees_projects' join table
begin
  ActiveRecord::Base.connection.create_table TABLE_EMPLOYEES_PROJECTS do |t|
    t.references :employee, null: false, foreign_key: true
    t.references :project, null: false, foreign_key: true
  end
  puts "Table '#{TABLE_EMPLOYEES_PROJECTS}' created with columns: employee_id, project_id."
rescue ActiveRecord::StatementInvalid
  puts "[create_table] Table '#{TABLE_EMPLOYEES_PROJECTS}' already exists."
rescue ActiveRecord::ActiveRecordError => e
  puts "[create_table] Error occurred while creating table: #{e.message}"
end
