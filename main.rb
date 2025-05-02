# Require necessary gems
require "rubygems"
require "active_record"

# Establish connection to the database
require_relative "database/databaseConnection"

# Method to print table names and columns in aligned format
def print_tables_info
  ActiveRecord::Base.connection.tables.each do |table|
    columns = ActiveRecord::Base.connection.columns(table).map(&:name).join(", ")
    puts format("> %-20s %s", table, columns)
  end
end

def create_tables
  puts "[1] Creating database tables..."

  # Load the create files
  require_relative "creators/createEnterprises"
  require_relative "creators/createEmployees"
  require_relative "creators/createProjects"
  require_relative "creators/createEmployeesProjects"

  puts "\nSuccessfully created tables:"
  print_tables_info
end

def load_models
  puts "\n[2] Loading models..."

  # Load the model files
  require_relative "models/employee"

  puts "\nSuccessfully loaded models:"
  puts format("> %-20s %s", "Employee", Employee.columns.map(&:name).join(", "))
end

create_tables
load_models

puts "\nProgram completed successfully."
