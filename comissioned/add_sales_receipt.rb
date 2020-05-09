# frozen_string_literal: true

require_relative 'sales_receipt'

# Business Logic Which Adds a SalesReceipt into the system
module Comissioned
  AddSalesReceipt = ImmutableStruct.new(:id, :date, :amount, :database) do
    def execute
      employee = database.employee(id)
      pay_check = employee.classification
      pay_check.add_sales_receipt(SalesReceipt.new(date: date, amount: amount))
    end
  end
end
