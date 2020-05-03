require "minitest/autorun"
require_relative "../add_service_charge"
require_relative "../add_hourly_employee"
require_relative "../change_union_member"
require_relative "../payroll_database"
require "date"

describe AddServiceCharge do
  it "should create a service for an employee" do
    empId = 7
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(empId, "Bill", "Home", 15.25, database)
    t.execute

    e = database.get_employee(empId)
    e.wont_be_nil

    memberId = 86
    ChangeUnionMember.new(empId, memberId, 10.0, database).execute

    sct = AddServiceCharge.new(memberId, Date.new(2005, 8, 8), 12.95, database)
    sct.execute

    sc = e.affiliation.get_service_charge(Date.new(2005, 8, 8))
    sc.wont_be_nil
    sc.charge.must_be_close_to 12.95
    sc.date.must_equal Date.new(2005, 8, 8)
  end
end
