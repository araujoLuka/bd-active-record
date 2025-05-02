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

puts "\nInitialization completed successfully."

require "readline"

puts "\n[3] Entering console mode..."
puts "Type 'help' for a list of commands."

loop do
  input = Readline.readline("> ", true) # Enable history
  command, table, *attributes = input.split

  case command
  when "help"
    puts "Available commands:"
    puts "  insere  <tabela> { atributo=valor }  - Insert a new record"
    puts "  altera  <tabela> { atributo=valor }  - Update an existing record"
    puts "  exclui  <tabela> id                  - Delete a record"
    puts "  lista   <tabela>                     - List records in a table"
    puts ""
    # Remember the user that the database information needed are already printed before
    puts "The needed database information is already printed above."
    puts "Check them out to know the tables and their attributes."
  when "insere"
    puts "Inserindo em #{table}: #{attributes.join(", ")}"
    insert_employee(attributes)
  when "altera"
    puts "Alterando em #{table}: #{attributes.join(", ")}"
    update_employee(attributes)
  when "exclui"
    puts "Excluindo de #{table}: #{attributes.join(", ")}"
    delete_employee(*attributes)
  when "lista"
    puts "Listando #{table}"
    list_employees
  else
    puts "Comando inválido"
  end
end

puts "\nExiting console mode. Goodbye!"
