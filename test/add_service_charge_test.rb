require "minitest/autorun"
require_relative "../add_service_charge"
require_relative "../add_hourly_employee"
require_relative "../union_affiliation"
require "date"

describe AddServiceCharge do
  it "should create a service for an employee" do
    empId = 7
    t = AddHourlyEmployee.new(empId, "Bill", "Home", 15.25)
    t.execute

    e = PayrollDatabase.get_employee(empId)
    e.wont_be_nil

    af = UnionAffiliation.new
    e.affiliation = af

    memberId = 86
    PayrollDatabase.add_union_member(memberId, e)

    sct = AddServiceCharge.new(memberId, Date.new(2005, 8, 8), 12.95)
    sct.execute

    sc = af.get_service_charge(Date.new(2005, 8, 8))
    sc.wont_be_nil
  end
end
