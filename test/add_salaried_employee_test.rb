require "minitest/autorun"
require_relative "../add_salaried_employee"
require_relative "../payroll_database"

describe AddSalariedEmployee do
  it "should create a salaried employee" do
    empId = 1
    t = AddSalariedEmployee.new(empId, "Bob", "Home", 1100.00)
    t.execute

    e = PayrollDatabase.get_employee(empId)
    e.name.must_equal "Bob"
    e.address.must_equal "Home"

    pc = e.classification
    pc.salary.must_be_close_to 1100, 0.001

    ps = e.schedule
    ps.must_be_kind_of MonthlySchedule

    pm = e.payment_method
    pm.must_be_kind_of HoldMethod
  end
end
