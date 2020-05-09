# frozen_string_literal: true

require_relative '../change_employee'

# Business Logic Which Changes the Employee Address
ChangeAddress = ImmutableStruct.new(:id, :address, :database) do
  include ::ChangeEmployee

  def change(employee)
    employee.address = address
  end
end
