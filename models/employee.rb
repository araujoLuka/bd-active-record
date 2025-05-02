# Require necessary gems
require "rubygems"
require "active_record"

# Establish connection to the database
require_relative "../database/databaseConnection"

# Model definition for Employee
class Employee < ActiveRecord::Base
  # Default values for attributes
  attribute :position, :string, default: "Unknown"
  attribute :salary, :decimal, default: 1000.0

  # Associations
  has_many :employees_projects
  has_many :projects, through: :employees_projects

  # Validations
  validates :name, presence: true
  validates :salary, numericality: {greater_than: 0}
  validates :age, numericality: {only_integer: true, greater_than: 0}
  validate :validate_position

  # Positions for employees
  @@positions = [
    "Unknown",
    "Software Engineer",
    "Data Scientist",
    "Project Manager",
    "UX Designer",
    "DevOps Engineer",
    "Business Analyst"
  ]

  # Getter for employee positions
  def self.positions
    @@positions
  end

  private

  # Validate the position
  def validate_position
    unless @@positions.include?(position)
      errors.add(:position, "is not a valid position.")
    end
  end
end

def insert_employee(attributes)
  # Convert attributes to a hash
  attribute_hash = attributes.each_with_object({}) do |attr, hash|
    key, value = attr.split("=")
    hash[key] = value.tr('"', "") # Remove quotes from value
  end

  employee = Employee.new(attribute_hash)
  if employee.save
    puts "Employee created successfully: #{employee.attributes}"
  else
    puts "Error creating employee: #{employee.errors.full_messages.join(", ")}"
  end
rescue => e
  puts "An error occurred: #{e.message}"
end

def update_employee(id, attributes)
  employee = Employee.find(id)
  attribute_hash = attributes.each_with_object({}) do |attr, hash|
    key, value = attr.split("=")
    hash[key] = value.tr('"', "")
  end

  if employee.update(attribute_hash)
    puts "Employee updated successfully: #{employee.attributes}"
  else
    puts "Error updating employee: #{employee.errors.full_messages.join(", ")}"
  end
rescue ActiveRecord::RecordNotFound
  puts "Employee not found."
rescue => e
  puts "An error occurred: #{e.message}"
end

def delete_employee(id)
  employee = Employee.find(id)
  if employee.delete
    puts "Employee deleted successfully: #{employee.attributes}"
  else
    puts "Error deleting employee."
  end
rescue ActiveRecord::RecordNotFound
  puts "Employee not found."
rescue => e
  puts "An error occurred: #{e.message}"
end

def list_employees
  employees = Employee.all
  if employees.any?
    employees.each do |employee|
      puts "ID: #{employee.id}, Name: #{employee.name}, Position: #{employee.position}, Salary: #{employee.salary}"
    end
  else
    puts "No employees found."
  end
end

puts "Employee model loaded successfully."
