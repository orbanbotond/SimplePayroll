require "minitest/autorun"
require_relative "../change_union_member"
require_relative "../add_hourly_employee"

describe ChangeUnionMember do
  it "should change an employee to have a union affiliation" do
    empId = 12
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(empId, "Bill", "Home", 1500, database)
    t.execute

    memberId = 7743
    cut = ChangeUnionMember.new(empId, memberId, 99.42, database)
    cut.execute

    e = database.get_employee(empId)
    e.wont_be_nil

    af = e.affiliation
    af.wont_be_nil
    af.dues.must_be_close_to 99.42, 0.001

    member = database.get_union_member(memberId)
    member.wont_be_nil
    member.must_equal e
  end
end
