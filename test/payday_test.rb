# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../payday'
require_relative '../payroll_database'
require_relative '../add_salaried_employee'
require_relative '../add_hourly_employee'
require_relative '../add_time_card'
require_relative '../add_service_charge'
require_relative '../add_sales_receipt'
require_relative '../add_commissioned_employee'
require_relative '../change_union_member'
require 'date'

# rubocop:disable Metrics/BlockLength
describe Payday do
  database = PayrollDatabase.new

  it 'should pay a single salaried employee' do
    emp_id = 13
    t = AddSalariedEmployee.new(emp_id, 'Bill', 'Home', 1000.0, database)
    t.execute

    pay_date = Date.new(2001, 11, 30)
    payday = Payday.new(pay_date, database)
    payday.execute

    pay_check = payday.get_paycheck(emp_id)
    pay_check.pay_date.must_equal pay_date
    pay_check.gross_pay.must_be_close_to 1000.0, 0.001
    pay_check.disposition.must_equal 'Hold'
    pay_check.deductions.must_be_close_to 0.0, 0.001
    pay_check.net_pay.must_be_close_to 1000.0, 0.001
  end

  it 'should not pay a salaried employee on wrong date' do
    emp_id = 14
    t = AddSalariedEmployee.new(emp_id, 'Bob', 'Home', 1100.0, database)
    t.execute

    pay_date = Date.new(2001, 11, 29)
    payday = Payday.new(pay_date, database)
    payday.execute
    pay_check = payday.get_paycheck(emp_id)
    pay_check.must_be_nil
  end

  it 'should pay 0 to a single hourly employee with no time cards' do
    emp_id = 15
    t = AddHourlyEmployee.new(emp_id, 'Bob', 'Home', 15.25, database)
    t.execute

    pay_date = Date.new(2001, 11, 9)
    payday = Payday.new(pay_date, database)
    payday.execute

    validate_hourly_paycheck(payday, emp_id, pay_date, 0.0)
  end

  it 'should pay a single hourly employe with one time card' do
    emp_id = 16
    t = AddHourlyEmployee.new(emp_id, 'Bill', 'Home', 15.25, database)
    t.execute

    pay_date = Date.new(2001, 11, 9)
    tc = AddTimeCard.new(pay_date, 2.0, emp_id, database)
    tc.execute

    payday = Payday.new(pay_date, database)
    payday.execute

    validate_hourly_paycheck(payday, emp_id, pay_date, 30.5)
  end

  it 'should pay for over time' do
    emp_id = 17
    rate = 15.25
    t = AddHourlyEmployee.new(emp_id, 'Bob', 'Home', rate, database)
    t.execute

    pay_date = Date.new(2001, 11, 9)
    regular_hours = 8
    overtime_hours = 1
    tc = AddTimeCard.new(pay_date, regular_hours + overtime_hours, emp_id, database)
    tc.execute

    payday = Payday.new(pay_date, database)
    payday.execute
    overtime_ratio = 1.5
    validate_hourly_paycheck(payday, emp_id, pay_date, (regular_hours + overtime_hours * overtime_ratio) * rate)
  end

  it 'should not pay hourly employee on wrong date' do
    emp_id = 18
    t = AddHourlyEmployee.new(emp_id, 'Bill', 'Home', 15.25, database)
    t.execute
    pay_date = Date.new(2001, 11, 8)
    tc = AddTimeCard.new(pay_date, 9.0, emp_id, database)
    tc.execute

    payday = Payday.new(pay_date, database)
    payday.execute
    payday.get_paycheck(emp_id).must_be_nil
  end

  it 'should pay hourly employee two time cards' do
    emp_id = 19
    t = AddHourlyEmployee.new(emp_id, 'Bob', 'Home', 15.25, database)
    t.execute
    pay_date = Date.new(2001, 11, 9)
    tc = AddTimeCard.new(pay_date, 5.0, emp_id, database)
    tc.execute
    tc = AddTimeCard.new(pay_date - 1, 6.0, emp_id, database)
    tc.execute

    payday = Payday.new(pay_date, database)
    payday.execute
    validate_hourly_paycheck(payday, emp_id, pay_date, 11 * 15.25)
  end

  it 'should pay only one pay period' do
    emp_id = 20
    t = AddHourlyEmployee.new(emp_id, 'Bill', 'Home', 15.25, database)
    t.execute

    pay_date = Date.new(2001, 11, 9)
    tc = AddTimeCard.new(pay_date, 5.0, emp_id, database)
    tc.execute
    tc = AddTimeCard.new(pay_date - 1, 4.0, emp_id, database)
    tc.execute
    tc = AddTimeCard.new(pay_date - 7, 6.0, emp_id, database)
    tc.execute
    tc = AddTimeCard.new(pay_date + 7, 6.0, emp_id, database)
    tc.execute

    payday = Payday.new(pay_date, database)
    payday.execute
    validate_hourly_paycheck(payday, emp_id, pay_date, (5 + 4) * 15.25)
  end

  it 'should pay a commissioned employee with no commission' do
    emp_id = 22
    t = AddCommissionedEmployee.new(emp_id, 'Bob', 'Home', 1000.0, 2.5, database)
    t.execute

    pay_date = Date.new(2001, 11, 16)
    payday = Payday.new(pay_date, database)
    payday.execute
    validate_commissioned_paycheck(payday, emp_id, pay_date, 1000.0)
  end

  it 'should pay a commissioned employee with one commission only for current pay period' do
    emp_id = 23
    t = AddCommissionedEmployee.new(emp_id, 'Bob', 'Home', 1000.0, 10.0, database)
    t.execute

    pay_date = Date.new(2001, 11, 16)
    AddSalesReceipt.new(emp_id, pay_date, 500, database).execute
    AddSalesReceipt.new(emp_id, pay_date, 300, database).execute
    AddSalesReceipt.new(emp_id, pay_date - 14, 500, database).execute
    AddSalesReceipt.new(emp_id, pay_date + 14, 500, database).execute

    payday = Payday.new(pay_date, database)
    payday.execute
    validate_commissioned_paycheck(payday, emp_id, pay_date, 1000 + (500 + 300) * 10 / 100)
  end

  it 'should not pay a commissioned employee on wrong date' do
    emp_id = 24
    t = AddCommissionedEmployee.new(emp_id, 'Bob', 'Home', 1000.0, 2.5, database)
    t.execute

    pay_date = Date.new(2001, 11, 23)
    payday = Payday.new(pay_date, database)
    payday.execute
    payday.get_paycheck(emp_id).must_be_nil
  end

  it 'should deduct service charges from member' do
    emp_id = 25
    t = AddHourlyEmployee.new(emp_id, 'Bob', 'Home', 15.24, database)
    t.execute

    member_id = 777
    cmt = ChangeUnionMember.new(emp_id, member_id, 9.42, database)
    cmt.execute

    pay_date = Date.new(2001, 11, 9)
    sct = AddServiceCharge.new(member_id, pay_date, 19.42, database)
    sct.execute

    tct = AddTimeCard.new(pay_date, 8.0, emp_id, database)
    tct.execute

    payday = Payday.new(pay_date, database)
    payday.execute

    pay_check = payday.get_paycheck(emp_id)
    pay_check.wont_be_nil
    pay_check.pay_date.must_equal pay_date
    pay_check.gross_pay.must_be_close_to 8 * 15.24, 0.001
    pay_check.disposition.must_equal 'Hold'
    pay_check.deductions.must_be_close_to 9.42 + 19.42, 0.001
  end

  it 'should deduct service charges correct when spanning multiple pay periods' do
    emp_id = 26
    t = AddHourlyEmployee.new(emp_id, 'Bill', 'Home', 15.25, database)
    t.execute

    member_id = 778
    cmt = ChangeUnionMember.new(emp_id, member_id, 9.42, database)
    cmt.execute

    pay_date = Date.new(2001, 11, 9)
    early_date = pay_date - 7
    late_date = pay_date + 7
    sct = AddServiceCharge.new(member_id, pay_date, 19.42, database)
    sct.execute

    sct_early = AddServiceCharge.new(member_id, early_date, 100.00, database)
    sct_early.execute
    sct_late = AddServiceCharge.new(member_id, late_date, 200.00, database)
    sct_late.execute

    tct = AddTimeCard.new(pay_date, 8.0, emp_id, database)
    tct.execute

    payday = Payday.new(pay_date, database)
    payday.execute

    pay_check = payday.get_paycheck(emp_id)
    pay_check.wont_be_nil
    pay_check.gross_pay.must_be_close_to 8.0 * 15.25, 0.001
    pay_check.deductions.must_be_close_to 9.42 + 19.42, 0.001
    pay_check.net_pay.must_be_close_to 8.0 * 15.25 - 9.42 - 19.42, 0.001
  end

  def validate_hourly_paycheck(payday, emp_id, pay_date, pay)
    validate_paycheck(payday, emp_id, pay_date, pay)
  end

  def validate_commissioned_paycheck(payday, emp_id, pay_date, pay)
    validate_hourly_paycheck(payday, emp_id, pay_date, pay)
  end

  def validate_paycheck(payday, emp_id, pay_date, pay)
    pay_check = payday.get_paycheck(emp_id)
    pay_check.wont_be_nil
    pay_check.pay_date.must_equal pay_date
    pay_check.gross_pay.must_be_close_to pay, 0.001
    pay_check.disposition.must_equal 'Hold'
    pay_check.deductions.must_be_close_to 0.0, 0.001
    pay_check.net_pay.must_be_close_to pay, 0.001
  end
end
