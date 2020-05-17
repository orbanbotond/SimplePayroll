# frozen_string_literal: true

# Business Logic Which Changes the Employee Address
module Operations
  ChangeAddress = ImmutableStruct.new(:id, :address, :database) do
    include ::ChangeEmployee

    def change(employee)
      employee.address = address
    end
  end
end
