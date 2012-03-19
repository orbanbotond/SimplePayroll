require "minitest/autorun"
require_relative "../add_sales_receipt"
require_relative "../add_commissioned_employee"
require "date"

describe AddSalesReceipt do
  it "should add a sales recepit to an employee" do
    empId = 6
    t = AddCommissionedEmployee.new(empId, "John", "Home", 1500, 2.5)
    t.execute

    srt = AddSalesReceipt.new(empId, Date.new(2005, 3, 30), 500)
    srt.execute

    e = PayrollDatabase.get_employee(empId)
    e.wont_be_nil

    pc = e.classification
    pc.must_be_kind_of CommissionedClassification

    srs = pc.get_sales_receipts
    srs.first.amount.must_equal 500
  end
end
