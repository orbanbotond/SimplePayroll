# frozen_string_literal: true

# The common Business Logic functionality for addEmployee
# It assumes that it responds to:
# - id
# - name
# - address
# - make_classification
# - make_schedule
module AddEmployee
  attr_accessor :id

  def execute
    employee = Employee.new(id, name, address)
    employee.classification = make_classification
    employee.schedule = make_schedule
    employee.payment_method = PaymentMethods::Hold.new

    persisted = database.add_employee(id, employee)
    employee.id = persisted.id
    employee.classification.id = persisted.classification.id
    employee.schedule.id = persisted.schedule.id
    employee.payment_method.id = persisted.payment_method.id
  end
end
