# frozen_string_literal: true

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
    employee.payment_method = PaymentMethods::Hold.new

    database.add_employee(id, employee)
  end
end
