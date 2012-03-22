require "minitest/autorun"
require_relative "../change_address"
require_relative "../add_hourly_employee"

describe ChangeAddress do
  it "should change an employees address" do
    empId = 8
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(empId, "Bill", "Work", 20.0, database)
    t.execute

    cat = ChangeAddress.new(empId, "Home", database)
    cat.execute

    e = database.get_employee(empId)
    e.wont_be_nil
    e.address.must_equal "Home"
  end
end
