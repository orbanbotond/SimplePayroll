# frozen_string_literal: true

require_relative '../change_employee'

# Business Logic Which Changes the Employee Address
ChangeName = ImmutableStruct.new(:id, :name, :database) do
  include ::ChangeEmployee

  def change(employee)
    employee.name = name
  end
end
