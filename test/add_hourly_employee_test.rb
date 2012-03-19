require "minitest/autorun"
require_relative "../add_hourly_employee"

describe AddHourlyEmployee do
  it "should create an hourly employee" do
    empId = 2
    t = AddHourlyEmployee.new(empId, "John", "Work", 20.0)
    t.execute

    e = PayrollDatabase.get_employee(empId)
    e.name.must_equal "John"
    e.address.must_equal "Work"

    pc = e.classification
    pc.rate.must_be_close_to 20.0, 0.0001

    ps = e.schedule
    ps.must_be_kind_of WeeklySchedule

    pm = e.payment_method
    pm.must_be_kind_of HoldMethod
  end
end
