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
  require_relative "models/enterprise"
  require_relative "models/project"

  puts "\nSuccessfully loaded models:"
  puts format("> %-20s %s", "Employee", Employee.columns.map(&:name).join(", "))
end

create_tables
load_models

puts "\nInitialization completed successfully."

require "readline"

puts "\n[3] Entering console mode..."
puts "Type 'help' for a list of commands."

def insert_command(table, attributes)
  case table
  when "employees"
    insert_employee(attributes)
  when "enterprises"
    insert_enterprise(attributes)
  when "projects"
    insert_project(attributes)
  else
    puts "Tabela não reconhecida: #{table}. Tente 'employees', 'enterprises' ou 'projects'."
  end
rescue => e
  puts "An error occurred: #{table}: #{e.message}"
end

def update_command(table, id, attributes)
  case table
  when "employees"
    update_employee(id, attributes)
  when "enterprises"
    update_enterprise(id, attributes)
  when "projects"
    update_project(id, attributes)
  else
    puts "Tabela não reconhecida: #{table}. Tente 'employees', 'enterprises' ou 'projects'."
  end
rescue => e
  puts "An error occurred: #{table}: #{e.message}"
end

def delete_command(table, id)
  case table
  when "employees"
    delete_employee(id)
  when "enterprises"
    delete_enterprise(id)
  when "projects"
    delete_project(id)
  else
    puts "Tabela não reconhecida: #{table}. Tente 'employees', 'enterprises' ou 'projects'."
  end
rescue => e
  puts "An error occurred: #{table}: #{e.message}"
end

def list_command(table)
  case table
  when "employees"
    list_employees
  when "enterprises"
    list_enterprises
  when "projects"
    list_projects
  else
    puts "Tabela não reconhecida: #{table}. Tente 'employees', 'enterprises' ou 'projects'."
  end
rescue => e
  puts "An error occurred: #{table}: #{e.message}"
end

loop do
  input = Readline.readline("> ", true) # Enable history

  break if input.nil? || input.strip.empty?

  command, table, *attributes = input.split

  # Processes attributes that may contain whitespace (e.g., "name=\"John Doe\"").
  # The goal is to avoid splitting these attributes, as they should be treated as a single unit.
  # If the item does not contain '=', it will be combined with the previous attribute.
  new_attributes = []
  attributes.each do |attr|
    if attr.include?("=")
      key, value = attr.split("=")
      new_attributes << "#{key}=#{value.tr('"', "")}" # Remove quotes from value
    elsif new_attributes.any?
      new_attributes[-1] = "#{new_attributes.last} #{attr}"
    end
  end
  attributes.replace(new_attributes)

  case command
  when "help"
    puts "Available commands:"
    puts "  insere <tabela> { atributo=valor } - Insert a new record"
    puts "  altera <tabela> id=valor { atributo=valor } - Update an existing record"
    puts "  exclui <tabela> id=valor - Delete a record"
    puts "  lista <tabela> - List records in a table"
    puts "  exit - Exit the console"
    puts ""
    puts "Attention: the '{ atributo=valor }' means repetitions of different attributes."
    puts "Example: insere employees name=\"John Doe\" position=\"Developer\" salary=50000"
    puts ""
    puts "The necessary information for each table are provided above, in the previous prints"
  when "insere"
    insert_command(table, attributes)
  when "altera"
    if attributes[0].include?("id=") == false
      puts "ERROR: Missing id=valor in the command."
    else
      id = attributes[0].split("=")[1]
      attributes.shift # Remove the id attribute from the list
      update_command(table, id, attributes)
    end
  when "exclui"
    if attributes[0].include?("id=") == false
      puts "ERROR: Missing id=valor in the command."
    else
      id = attributes[0].split("=")[1]
      attributes.shift # Remove the id attribute from the list
      delete_command(table, id)
    end
  when "lista"
    list_command(table)
  when "exit"
    break
  else
    puts "Comando inválido"
  end
end

puts "\nExiting console mode. Goodbye!"
