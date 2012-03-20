require "minitest/autorun"
require_relative "../change_union_member"
require_relative "../add_hourly_employee"

describe ChangeUnionMember do
  it "should change an employee to have a union affiliation" do
    empId = 12
    t = AddHourlyEmployee.new(empId, "Bill", "Home", 1500)
    t.execute

    memberId = 7743
    cut = ChangeUnionMember.new(empId, memberId, 99.42)
    cut.execute

    e = PayrollDatabase.get_employee(empId)
    e.wont_be_nil

    af = e.affiliation
    af.wont_be_nil
    af.dues.must_be_close_to 99.42, 0.001

    member = PayrollDatabase.get_union_member(memberId)
    member.wont_be_nil
    member.must_equal e
  end
end
