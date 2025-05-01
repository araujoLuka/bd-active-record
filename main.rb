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
  require_relative "employee"

  # test the model
  employee = Employee.new
  employee.name = "John Doe"
  employee.position = Employee.positions[0]
  employee.salary = 60000
  employee.age = 30
  puts "Employee created: #{employee.name}, Position: #{employee.position}, Salary: #{employee.salary}, Age: #{employee.age}"
  puts "Validations passed: #{employee.valid?}"
  puts "Errors: #{employee.errors.full_messages.join(", ")}" unless employee.valid?
  employee.save if employee.valid?
  puts "Employee saved to database."
  puts ActiveRecord::Base.connection.tables.inspect
  puts "Employee ID: #{employee.id}" if employee.persisted?
  employee_found = Employee.find_by(name: "John Doe")
  if employee_found
    puts "Employee found: #{employee_found.name}, Position: #{employee_found.position}, Salary: #{employee_found.salary}, Age: #{employee_found.age}"
  else
    puts "Employee not found."
  end
  employee_found&.delete

  puts "---"
end

create_tables
create_models

puts "\nProgram completed successfully."
