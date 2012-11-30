require "minitest/autorun"
require_relative "../payday"
require_relative "../payroll_database"
require_relative "../add_salaried_employee"
require_relative "../add_hourly_employee"
require_relative "../add_time_card"
require_relative "../add_service_charge"
require_relative "../add_commissioned_employee"
require_relative "../change_union_member"
require "date"

describe Payday do
    database = PayrollDatabase.new

  it "should pay a single salaried employee" do
    empId = 13
    t = AddSalariedEmployee.new(empId, "Bill", "Home", 1000.0, database)
    t.execute

    pay_date = Date.new(2001, 11, 30)
    pt = Payday.new(pay_date, database)
    pt.execute

    pc = pt.get_paycheck(empId)
    pc.pay_date.must_equal pay_date
    pc.gross_pay.must_be_close_to 1000.0, 0.001
    pc.disposition.must_equal "Hold"
    pc.deductions.must_be_close_to 0.0, 0.001
    pc.net_pay.must_be_close_to 1000.0, 0.001
  end

  it "should not pay a salaried employee on wrong date" do
    empId = 14
    t = AddSalariedEmployee.new(empId, "Bob", "Home", 1100.0, database)
    t.execute

    pay_date = Date.new(2001, 11, 29)
    pt = Payday.new(pay_date, database)
    pt.execute
    pc = pt.get_paycheck(empId)
    pc.must_be_nil
  end

  it "should pay 0 to a single hourly employee with no time cards" do
    empId = 15
    t = AddHourlyEmployee.new(empId, "Bob", "Home", 15.25, database)
    t.execute

    pay_date = Date.new(2001, 11, 9)
    pt = Payday.new(pay_date, database)
    pt.execute

    validate_hourly_paycheck(pt, empId, pay_date, 0.0)
  end

  it "should pay a single hourly employe with one time card" do
    empId = 16
    t = AddHourlyEmployee.new(empId, "Bill", "Home", 15.25, database)
    t.execute

    pay_date = Date.new(2001, 11, 9)
    tc = AddTimeCard.new(pay_date, 2.0, empId, database)
    tc.execute

    pt = Payday.new(pay_date, database)
    pt.execute

    validate_hourly_paycheck(pt, empId, pay_date, 30.5)
  end

  it "should pay for over time" do
    empId = 17
    t = AddHourlyEmployee.new(empId, "Bob", "Home", 15.25, database)
    t.execute

    pay_date = Date.new(2001, 11, 9)
    tc = AddTimeCard.new(pay_date, 9.0, empId, database)
    tc.execute

    pt = Payday.new(pay_date, database)
    pt.execute
    validate_hourly_paycheck(pt, empId, pay_date, (8+1.5) * 15.25)
  end

  it "should not pay hourly employee on wrong date" do
    empId = 18
    t = AddHourlyEmployee.new(empId, "Bill", "Home", 15.25, database)
    t.execute
    pay_date = Date.new(2001, 11, 8)
    tc = AddTimeCard.new(pay_date, 9.0, empId, database)
    tc.execute

    pt = Payday.new(pay_date, database)
    pt.execute
    pt.get_paycheck(empId).must_be_nil
  end

  it "should pay hourly employee two time cards" do
    empId = 19
    t = AddHourlyEmployee.new(empId, "Bob", "Home", 15.25, database)
    t.execute
    pay_date = Date.new(2001, 11, 9)
    tc = AddTimeCard.new(pay_date, 5.0, empId, database)
    tc.execute
    tc = AddTimeCard.new(pay_date - 1, 6.0, empId, database)
    tc.execute

    pt = Payday.new(pay_date, database)
    pt.execute
    validate_hourly_paycheck(pt, empId, pay_date, 11*15.25)
  end

  it "should pay only one pay period" do
    empId = 20
    t = AddHourlyEmployee.new(empId, "Bill", "Home", 15.25, database)
    t.execute

    pay_date = Date.new(2001, 11, 9)
    tc = AddTimeCard.new(pay_date, 5.0, empId, database)
    tc.execute
    tc = AddTimeCard.new(pay_date-7, 6.0, empId, database)
    tc.execute
    tc = AddTimeCard.new(pay_date+7, 6.0, empId, database)
    tc.execute

    pt = Payday.new(pay_date, database)
    pt.execute
    validate_hourly_paycheck(pt, empId, pay_date, 5*15.25)
  end

  it "should pay a commissiond employee with no commission" do
    empId = 21
    t = AddCommissionedEmployee.new(empId, "Bob", "Home", 1000.0, 2.5, database)
    t.execute

    pay_date = Date.new(2001, 11, 16)
    pt = Payday.new(pay_date, database)
    pt.execute
    validate_commissioned_paycheck(pt, empId, pay_date, 1000.0)
  end

  it "should deduct service charges from member" do
    empId = 22
    t = AddHourlyEmployee.new(empId, "Bob", "Home", 15.24, database)
    t.execute

    memberId = 777
    cmt = ChangeUnionMember.new(empId, memberId, 9.42, database)
    cmt.execute

    pay_date = Date.new(2001, 11, 9)
    sct = AddServiceCharge.new(memberId, pay_date, 19.42, database)
    sct.execute

    tct = AddTimeCard.new(pay_date, 8.0, empId, database)
    tct.execute

    pt = Payday.new(pay_date, database)
    pt.execute

    pc = pt.get_paycheck(empId)
    pc.wont_be_nil
    pc.pay_date.must_equal pay_date
    pc.gross_pay.must_be_close_to 8*15.24, 0.001
    pc.disposition.must_equal "Hold"
    pc.deductions.must_be_close_to 9.42 + 19.42, 0.001
  end

  it "should deduct service charges correct when spanning multiple pay periods" do
    empId = 23
    t = AddHourlyEmployee.new(empId, "Bill", "Home", 15.25, database)
    t.execute

    memberId = 778
    cmt = ChangeUnionMember.new(empId, memberId, 9.42, database)
    cmt.execute

    pay_date = Date.new(2001, 11, 9)
    early_date = pay_date - 7
    late_date = pay_date + 7
    sct = AddServiceCharge.new(memberId, pay_date, 19.42, database)
    sct.execute

    sct_early = AddServiceCharge.new(memberId, early_date, 100.00, database)
    sct_early.execute
    sct_late = AddServiceCharge.new(memberId, late_date, 200.00, database)
    sct_late.execute

    tct = AddTimeCard.new(pay_date, 8.0, empId, database)
    tct.execute

    pt = Payday.new(pay_date, database)
    pt.execute

    pc = pt.get_paycheck(empId)
    pc.wont_be_nil
    pc.gross_pay.must_be_close_to 8.0*15.25, 0.001
    pc.deductions.must_be_close_to 9.42 + 19.42, 0.001
    pc.net_pay.must_be_close_to 8.0*15.25 - 9.42 - 19.42, 0.001
  end

  def validate_hourly_paycheck(pt, empId, pay_date, pay)
    validate_paycheck(pt, empId, pay_date, pay)
  end

  def validate_commissioned_paycheck(pt, empId, pay_date, pay)
    validate_hourly_paycheck(pt, empId, pay_date, pay)
  end

  def validate_paycheck(pt, empId, pay_date, pay)
    pc = pt.get_paycheck(empId)
    pc.wont_be_nil
    pc.pay_date.must_equal pay_date
    pc.gross_pay.must_be_close_to pay, 0.001
    pc.disposition.must_equal "Hold"
    pc.deductions.must_be_close_to 0.0, 0.001
    pc.net_pay.must_be_close_to pay, 0.001
  end
end
