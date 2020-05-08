# frozen_string_literal: true

require_relative 'add_employee'
require_relative 'hourly_classification'
require_relative 'weekly_schedule'

# Business Logic Which Adds an Hourly Employee into the system
class AddHourlyEmployee < AddEmployee
  def initialize(id, name, address, rate, database)
    super(id, name, address, database)
    @rate = rate
  end

  def make_classification
    HourlyClassification.new(@rate)
  end

  def make_schedule
    WeeklySchedule.new
  end
end
