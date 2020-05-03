require "minitest/autorun"
require_relative "../change_name"
require_relative "../add_hourly_employee"
require_relative "../payroll_database"

describe ChangeName do
  it "should change the name of an employee" do
    empId = 2
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(empId, "Bill", "Home", 15.25, database)
    t.execute

    cnt = ChangeName.new(empId, "Bob", database)
    cnt.execute

    e = database.get_employee(empId)
    e.wont_be_nil
    e.name.must_equal "Bob"
  end
end
