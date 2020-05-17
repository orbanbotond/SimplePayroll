# frozen_string_literal: true

# Business Logic Which Adds a SalesReceipt into the system
module Classifications
  module Comissioned
    module Operations
      AddSalesReceipt = ImmutableStruct.new(:id, :date, :amount, :database) do
        def execute
          employee = database.employee(id)
          pay_check = employee.classification
          pay_check.add_sales_receipt(SalesReceipt.new(date: date, amount: amount))
        end
      end
    end
  end
end
