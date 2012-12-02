require_relative "sales_receipt"

class AddSalesReceipt
  def initialize(empId, date, amount, database)
    @empId = empId
    @date = date
    @amount = amount
    @database = database
  end

  def execute
    e = @database.get_employee(@empId)
    pc = e.classification
    pc.add_sales_receipt(SalesReceipt.new(@date, @amount))
  end
end
