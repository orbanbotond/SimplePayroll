# frozen_string_literal: true

require_relative '../payment_methods/hold_method'
require_relative 'employee'

# The common Business Logic functionality for addEmployee
# It assumes that it responds to:
# - id
# - name
# - address
# - make_classification
# - make_schedule
module AddEmployee
  def execute
    employee = Employee.new(id, name, address)
    employee.classification = make_classification
    employee.schedule = make_schedule
    employee.payment_method = HoldMethod.new

    database.add_employee(id, employee)
  end
end
