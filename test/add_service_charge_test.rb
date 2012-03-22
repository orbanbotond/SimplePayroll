require "minitest/autorun"
require_relative "../add_service_charge"
require_relative "../add_hourly_employee"
require_relative "../union_affiliation"
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
    af = UnionAffiliation.new(memberId, 10.0)
    e.affiliation = af

    database.add_union_member(memberId, e)

    sct = AddServiceCharge.new(memberId, Date.new(2005, 8, 8), 12.95, database)
    sct.execute

    sc = af.get_service_charge(Date.new(2005, 8, 8))
    sc.wont_be_nil
  end
end
