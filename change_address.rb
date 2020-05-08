# frozen_string_literal: true

require_relative 'change_employee'

# Business Logic Which Changes the Employee Address
class ChangeAddress < ChangeEmployee
  def initialize(emp_id, address, database)
    super(emp_id, database)
    @address = address
  end

  def change(employee)
    employee.address = @address
  end
end
