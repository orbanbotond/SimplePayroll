# frozen_string_literal: true

# Business Logic Which Deletes an employee
module Operations
  DeleteEmployee = ImmutableStruct.new(:id, :database) do
    def execute
      database.delete_employee(id)
    end
  end
end
