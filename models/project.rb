require "rubygems"
require "active_record"

class Project < ActiveRecord::Base
  # Default values for attributes
  attribute :title, :string, default: "Untitled Project"
  attribute :budget, :decimal, default: 1000.0

  # Associations
  belongs_to :enterprise
  has_and_belongs_to_many :employees

  # Validations
  validates :title, presence: true
  validates :budget, numericality: {greater_than: 0}
end

def insert_project(attributes)
  attribute_hash = attributes.each_with_object({}) do |attr, hash|
    key, value = attr.split("=")
    hash[key] = value.tr('"', "")
  end

  project = Project.new(attribute_hash)
  if project.save
    puts "Project created successfully."
  else
    puts "Error creating project: #{project.errors.full_messages.join(", ")}"
  end
rescue => e
  puts "An error occurred: #{e.message}"
end

def update_project(id, attributes)
  project = Project.find(id)
  attribute_hash = attributes.each_with_object({}) do |attr, hash|
    key, value = attr.split("=")
    hash[key] = value.tr('"', "")
  end

  if project.update(attribute_hash)
    puts "Project updated successfully."
  else
    puts "Error updating project: #{project.errors.full_messages.join(", ")}"
  end
rescue ActiveRecord::RecordNotFound
  puts "Project not found."
rescue => e
  puts "An error occurred: #{e.message}"
end

def delete_project(id)
  project = Project.find(id)
  if project.destroy
    puts "Project deleted successfully."
  else
    puts "Error deleting project."
  end
rescue ActiveRecord::RecordNotFound
  puts "Project not found."
rescue => e
  puts "An error occurred: #{e.message}"
end

def list_projects
  projects = Project.all
  if projects.any?
    projects.each do |project|
      puts "ID: #{project.id}, Title: #{project.title}, Budget: #{project.budget}"
    end
  else
    puts "No projects found."
  end
end

puts "Project model loaded successfully."
