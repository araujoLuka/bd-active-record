# Require necessary gems
require "rubygems"
require "active_record"

# Establish connection to the database
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/active_record.sqlite3"
)

# Create the 'employees' table
ActiveRecord::Base.connection.create_table :employees do |t|
  t.string :name
  t.string :position
  t.float :salary
  t.integer :age
end

puts "Table 'employees' created with columns: name, position, salary, age."
