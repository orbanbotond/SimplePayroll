# frozen_string_literal: true

# Business Logic Which Deletes an employee
class DeleteEmployee
  def initialize(emp_id, database)
    @emp_id = emp_id
    @database = database
  end

  def execute
    @database.delete_employee(@emp_id)
  end
end
