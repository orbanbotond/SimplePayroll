# frozen_string_literal: true

# Business Logic Which Changes the Employee Address
module Operations
  ChangeName = ImmutableStruct.new(:id, :name, :database) do
    include ::ChangeEmployee

    def change(employee)
      employee.name = name
    end
  end
end
