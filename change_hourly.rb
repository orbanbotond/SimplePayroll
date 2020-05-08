# frozen_string_literal: true

require_relative 'change_classification'

# Business Logic Which Changes the Employee Classification to Hourly
class ChangeHourly < ChangeClassification
  def initialize(emp_id, rate, database)
    super(emp_id, database)
    @rate = rate
  end

  def make_classification
    HourlyClassification.new(@rate)
  end

  def make_schedule
    WeeklySchedule.new
  end
end
