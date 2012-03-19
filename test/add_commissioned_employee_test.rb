require "minitest/autorun"
require_relative "../add_commissioned_employee"

describe AddCommissionedEmployee do
  it "should create a commissioned employee" do
    empId = 3
    t = AddCommissionedEmployee.new(empId, "Jim", "Garden", 500.0, 100.0)
    t.execute

    e = PayrollDatabase.get_employee(empId)
    e.name.must_equal "Jim"
    e.address.must_equal "Garden"

    pc = e.classification
    pc.salary.must_be_close_to 500.0, 0.0001
    pc.rate.must_be_close_to 100.0, 0.0001

    ps = e.schedule
    ps.must_be_kind_of BiweeklySchedule

    pm = e.payment_method
    pm.must_be_kind_of HoldMethod
  end
end
