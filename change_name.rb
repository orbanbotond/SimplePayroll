# frozen_string_literal: true

require_relative 'change_employee'

# Business Logic Which Changes the Employee Name
class ChangeName < ChangeEmployee
  def initialize(emp_id, name, database)
    super(emp_id, database)
    @name = name
  end

  def change(employee)
    employee.name = @name
  end
end
