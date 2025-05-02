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
    puts "Enterprise created successfully."
  else
    puts "Error creating enterprise: #{enterprise.errors.full_messages.join(", ")}"
  end
rescue => e
  puts "An error occurred: #{e.message}"
end

def update_enterprise(id, attributes)
  enterprise = Enterprise.find(id)
  attribute_hash = attributes.each_with_object({}) do |attr, hash|
    key, value = attr.split("=")
    hash[key] = value.tr('"', "")
  end

  if enterprise.update(attribute_hash)
    puts "Enterprise updated successfully."
  else
    puts "Error updating enterprise: #{enterprise.errors.full_messages.join(", ")}"
  end
rescue ActiveRecord::RecordNotFound
  puts "Enterprise not found."
rescue => e
  puts "An error occurred: #{e.message}"
end

def delete_enterprise(id)
  enterprise = Enterprise.find(id)
  if enterprise.destroy
    puts "Enterprise deleted successfully."
  else
    puts "Error deleting enterprise."
  end
rescue ActiveRecord::RecordNotFound
  puts "Enterprise not found."
rescue => e
  puts "An error occurred: #{e.message}"
end

def list_enterprises
  enterprises = Enterprise.includes(:projects).all
  if enterprises.any?
    enterprises.each do |enterprise|
      puts "ID: #{enterprise.id}, Name: #{enterprise.name}, Location: #{enterprise.location}"
      if enterprise.projects.any?
        puts "Projects:"
        enterprise.projects.each do |project|
          puts "  - Project ID: #{project.id}, Title: #{project.title}, Budget: #{project.budget}"
        end
      else
        puts "  No projects found."
      end
      if enterprise.employees.any?
        puts "Employees:"
        enterprise.employees.each do |employee|
          puts "  - Employee ID: #{employee.id}, Name: #{employee.name}, Position: #{employee.position}, Salary: #{employee.salary}"
        end
      else
        puts "  No employees found."
      end
    end
  else
    puts "No enterprises found."
  end
end

puts "Enterprise model loaded successfully."
