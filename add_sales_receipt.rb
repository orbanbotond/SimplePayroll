# frozen_string_literal: true

require_relative 'sales_receipt'

# Business Logic Which Adds a SalesReceipt into the system
class AddSalesReceipt
  def initialize(emp_id, date, amount, database)
    @emp_id = emp_id
    @date = date
    @amount = amount
    @database = database
  end

  def execute
    e = @database.get_employee(@emp_id)
    pay_check = e.classification
    pay_check.add_sales_receipt(SalesReceipt.new(@date, @amount))
  end
end
