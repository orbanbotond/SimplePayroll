# frozen_string_literal: true

require_relative 'time_card'

# Business Logic Which Adds a Time Card Into The System
class AddTimeCard
  def initialize(date, hours, emp_id, database)
    @date = date
    @hours = hours
    @emp_id = emp_id
    @database = database
  end

  def execute
    employee = @database.get_employee(@emp_id)
    raise 'No Employee Found' unless employee.present?

    hourly_classification = employee.classification
    hourly_classification.add_time_card(TimeCard.new(@date, @hours))
  end
end
