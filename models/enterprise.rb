require "rubygems"
require "active_record"

class Enterprise < ActiveRecord::Base
  # Default values for attributes
  attribute :name, :string, default: "Unknown Enterprise"
  attribute :location, :string, default: "Unknown Location"

  # Associations
  has_many :projects
  has_many :employees

  # Validations
  validates :name, presence: true
  validates :location, presence: true
end

def insert_enterprise(attributes)
  attribute_hash = attributes.each_with_object({}) do |attr, hash|
    key, value = attr.split("=")
    hash[key] = value.tr('"', "")
  end

  enterprise = Enterprise.new(attribute_hash)
  if enterprise.save
    puts "Enterprise created successfully: #{enterprise.attributes}"
  else
    puts "Error creating enterprise: #{enterprise.errors.full_messages.join(", ")}"
  end
end

def update_enterprise(id, attributes)
  enterprise = Enterprise.find(id)
  attribute_hash = attributes.each_with_object({}) do |attr, hash|
    key, value = attr.split("=")
    hash[key] = value.tr('"', "")
  end

  if enterprise.update(attribute_hash)
    puts "Enterprise updated successfully: #{enterprise.attributes}"
  else
    puts "Error updating enterprise: #{enterprise.errors.full_messages.join(", ")}"
  end
rescue ActiveRecord::RecordNotFound
  puts "ERROR: Enterprise not found."
end

def delete_enterprise(id)
  enterprise = Enterprise.find(id)
  if enterprise.destroy
    puts "Enterprise deleted successfully: #{enterprise.attributes}"
  else
    puts "Error deleting enterprise."
  end
rescue ActiveRecord::RecordNotFound
  puts "ERROR: Enterprise not found."
end

def list_enterprises
  puts "Listing all enterprises..."
  enterprises = Enterprise.includes(:projects, :employees).all
  if enterprises.any?
    enterprises.each do |enterprise|
      puts "  ID: #{enterprise.id}, Name: #{enterprise.name}, Location: #{enterprise.location}"
      puts "    Projects:"
      enterprise.projects.each do |project|
        puts "     |- #{project.id}: #{project.name}, Deadline: #{project.deadline}"
      end
      puts "    Employees:"
      enterprise.employees.each do |employee|
        puts "     |- #{employee.id}: #{employee.name}, #{employee.position}, Salary: #{employee.salary}"
      end
    end
  else
    puts "  No enterprises found."
  end
end

puts "Enterprise model loaded successfully."
