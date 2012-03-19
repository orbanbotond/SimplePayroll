require "minitest/autorun"
require_relative "../add_time_card"
require_relative "../add_hourly_employee"
require "date"

describe AddTimeCard do
  it "should add a timecard to an employee" do
    empId = 5
    t = AddHourlyEmployee.new(empId, "Bill", "Home", 15.25)
    t.execute

    tct = AddTimeCard.new(Date.new(2005, 7, 31), 8.0, empId)
    tct.execute

    e = PayrollDatabase.get_employee(empId)
    e.wont_be_nil

    pc = e.classification
    pc.must_be_kind_of HourlyClassification

    tc = pc.get_time_card(Date.new(2005, 7, 31))
    tc.wont_be_nil
    tc.hours.must_equal 8.0
  end
end
