# Require necessary gems
require "rubygems"
require "active_record"

# Establish connection to the database
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/active_record.sqlite3"
)

# Method to print table names and columns in aligned format
def print_tables_info
  ActiveRecord::Base.connection.tables.each do |table|
    columns = ActiveRecord::Base.connection.columns(table).map(&:name).join(", ")
    puts format("> %-20s %s", table, columns)
  end
end

def create_tables
  puts "[1] Creating database tables..."
  puts "---"

  # Load the create files
  require_relative "createEnterprises"
  require_relative "createEmployees"
  require_relative "createProjects"
  require_relative "createEmployeesProjects"

  puts "\nSuccessfully created tables:"
  print_tables_info

  puts "---"
end

def create_models
  puts "\n[2] Creating models..."
  puts "---"

  # Load the model files
  puts "TODO: Load the model files here"

  puts "---"
end

create_tables
create_models

puts "\nProgram completed successfully."
