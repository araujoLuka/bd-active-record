require "active_record"

DATABASE_ADAPTER = "sqlite3"
DATABASE_NAME = "active_record.sqlite3"

begin
  ActiveRecord::Base.establish_connection(
    adapter: DATABASE_ADAPTER,
    database: DATABASE_NAME
  )
rescue ActiveRecord::ConnectionNotEstablished => e
  puts "Error establishing connection to the database: #{e.message}"
  exit 1
rescue ActiveRecord::AdapterNotFound => e
  puts "Database adapter not found: #{e.message}"
  exit 2
rescue ActiveRecord::NoDatabaseError => e
  puts "Database not found: #{e.message}"
  exit 3
rescue ActiveRecord::ConnectionTimeoutError => e
  puts "Connection to the database timed out: #{e.message}"
  exit 4
rescue ActiveRecord::StatementInvalid => e
  puts "Invalid SQL statement: #{e.message}"
  exit 5
rescue e
  puts "An unexpected error occurred: #{e.message}"
  exit 6
end
