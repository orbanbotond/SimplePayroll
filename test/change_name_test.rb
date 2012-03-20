require "minitest/autorun"
require_relative "../change_name"
require_relative "../add_hourly_employee"

describe ChangeName do
  it "should change the name of an employee" do
    empId = 2
    t = AddHourlyEmployee.new(empId, "Bill", "Home", 15.25)
    t.execute

    cnt = ChangeName.new(empId, "Bob")
    cnt.execute

    e = PayrollDatabase.get_employee(empId)
    e.wont_be_nil
    e.name.must_equal "Bob"
  end
end
