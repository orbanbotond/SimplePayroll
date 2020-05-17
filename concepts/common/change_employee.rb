# frozen_string_literal: true

# Business Logic Module Which Changes the Employee
# expects to respond to these:
# - database
# - id
module ChangeEmployee
  def execute
    employee = database.employee(id)
    raise "Employee #{id} Not Found" unless employee.present?

    change(employee)
  end
end
