# frozen_string_literal: true

require_relative 'change_employee'

# A generic Business Logic Which Changes the Employee Classification
class ChangeClassification < ChangeEmployee
  def initialize(emp_id, database)
    super(emp_id, database)
  end

  def change(employee)
    employee.classification = make_classification
    employee.schedule = make_schedule
  end
end
