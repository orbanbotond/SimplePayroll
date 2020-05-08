# frozen_string_literal: true

# Business Logic Which Changes the Employee
class ChangeEmployee
  def initialize(emp_id, database)
    @emp_id = emp_id
    @database = database
  end

  def execute
    e = @database.get_employee(@emp_id)
    raise "Employee #{@emp_id} Not Found" unless e.present?

    change(e)
  end
end
