# Require necessary gems
require "rubygems"
require "active_record"

# Establish connection to the database
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "db/active_record.sqlite3"
)

# Model definition for Employee
class Employee < ActiveRecord::Base
  # Associations
  has_many :employees_projects
  has_many :projects, through: :employees_projects

  # Validations
  validates :name, presence: true
  validates :position, presence: true
  validates :salary, numericality: {greater_than: 0}
  validates :age, numericality: {only_integer: true, greater_than: 0}
  validate :validate_position

  # Positions for employees
  @@positions = [
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
