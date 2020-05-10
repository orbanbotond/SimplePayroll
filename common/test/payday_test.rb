# frozen_string_literal: true

require 'minitest/autorun'
require File.join(Dir.getwd, 'test_helper')
require 'payroll_database'
require 'salaried/operations/add_employee'
require 'hourly/operations/add_employee'
require 'hourly/operations/add_time_card'
require 'comissioned/operations/add_employee'
require 'comissioned/operations/add_sales_receipt'
require 'operations/affiliate'
require 'operations/add_service_charge'
require_relative '../operations/create_paychecks'
require 'date'

# rubocop:disable Metrics/BlockLength
describe CreatePaychecks do
  database = PayrollDatabase.new

  describe 'salaried classifications' do
    it 'should pay a single salaried employee' do
      id = 13
      Salaried::AddEmployee.new(id: id, name: 'Bill', address: 'Home', salary: 1000.0, database: database).execute

      pay_date = Date.new(2001, 11, 30)
      payday = CreatePaychecks.new(pay_date, database)
      payday.execute

      pay_check = payday.get_paycheck(id)
      pay_check.pay_date.must_equal pay_date
      pay_check.gross_pay.must_be_close_to 1000.0, 0.001
      pay_check.disposition.must_equal 'Hold'
      pay_check.deductions.must_be_close_to 0.0, 0.001
      pay_check.net_pay.must_be_close_to 1000.0, 0.001
    end

    it 'should not pay a salaried employee on wrong date' do
      id = 14
      Salaried::AddEmployee.new(id: id, name: 'Bob', address: 'Home', salary: 1100.0, database: database).execute

      pay_date = Date.new(2001, 11, 29)
      payday = CreatePaychecks.new(pay_date, database)
      payday.execute
      pay_check = payday.get_paycheck(id)
      pay_check.must_be_nil
    end
  end

  describe 'hourly classifications' do
    it 'should pay 0 to a single hourly employee with no time cards' do
      id = 15
      Hourly::AddEmployee.new(id: id, name: 'Bob', address: 'Home', rate: 15.25, database: database).execute

      pay_date = Date.new(2001, 11, 9)
      payday = CreatePaychecks.new(pay_date, database)
      payday.execute

      validate_hourly_paycheck(payday, id, pay_date, 0.0)
    end

    it 'should pay a single hourly employe with one time card' do
      id = 16
      Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.25, database: database).execute

      pay_date = Date.new(2001, 11, 9)
      Hourly::AddTimeCard.new(date: pay_date, hours: 2.0, id: id, database: database).execute

      payday = CreatePaychecks.new(pay_date, database)
      payday.execute

      validate_hourly_paycheck(payday, id, pay_date, 30.5)
    end

    it 'should pay for over time' do
      id = 17
      rate = 15.25
      Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: rate, database: database).execute

      pay_date = Date.new(2001, 11, 9)
      regular_hours = 8
      overtime_hours = 1
      Hourly::AddTimeCard.new(date: pay_date, hours: regular_hours + overtime_hours, id: id, database: database).execute

      payday = CreatePaychecks.new(pay_date, database)
      payday.execute
      overtime_ratio = 1.5
      validate_hourly_paycheck(payday, id, pay_date, (regular_hours + overtime_hours * overtime_ratio) * rate)
    end

    it 'should not pay hourly employee on wrong date' do
      id = 18
      Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.25, database: database).execute

      pay_date = Date.new(2001, 11, 8)
      Hourly::AddTimeCard.new(date: pay_date, hours: 9.0, id: id, database: database).execute

      payday = CreatePaychecks.new(pay_date, database)
      payday.execute
      payday.get_paycheck(id).must_be_nil
    end

    it 'should pay hourly employee two time cards' do
      id = 19
      Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.25, database: database).execute

      pay_date = Date.new(2001, 11, 9)
      Hourly::AddTimeCard.new(date: pay_date, hours: 5.0, id: id, database: database).execute
      Hourly::AddTimeCard.new(date: pay_date - 1, hours: 6.0, id: id, database: database).execute

      payday = CreatePaychecks.new(pay_date, database)
      payday.execute
      validate_hourly_paycheck(payday, id, pay_date, 11 * 15.25)
    end

    it 'should pay only one pay period' do
      id = 20
      Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.25, database: database).execute

      pay_date = Date.new(2001, 11, 9)
      Hourly::AddTimeCard.new(date: pay_date, hours: 5.0, id: id, database: database).execute
      Hourly::AddTimeCard.new(date: pay_date - 1, hours: 4.0, id: id, database: database).execute
      Hourly::AddTimeCard.new(date: pay_date - 7, hours: 6.0, id: id, database: database).execute
      Hourly::AddTimeCard.new(date: pay_date + 7, hours: 6.0, id: id, database: database).execute

      payday = CreatePaychecks.new(pay_date, database)
      payday.execute
      validate_hourly_paycheck(payday, id, pay_date, (5 + 4) * 15.25)
    end
  end

  describe 'comissioned classifications' do
    it 'should pay a commissioned employee with no commission' do
      id = 22
      Comissioned::AddEmployee.new(id: id, name: 'Bill', address: 'Home', salary: 1000.0, rate: 2.5, database: database).execute

      pay_date = Date.new(2001, 11, 16)
      payday = CreatePaychecks.new(pay_date, database)
      payday.execute
      validate_commissioned_paycheck(payday, id, pay_date, 1000.0)
    end

    it 'should pay a commissioned employee with one commission only for current pay period' do
      id = 23
      Comissioned::AddEmployee.new(id: id, name: 'Bill', address: 'Home', salary: 1000.0, rate: 10, database: database).execute

      pay_date = Date.new(2001, 11, 16)
      Comissioned::AddSalesReceipt.new(id: id, date: pay_date, amount: 500, database: database).execute
      Comissioned::AddSalesReceipt.new(id: id, date: pay_date, amount: 300, database: database).execute
      Comissioned::AddSalesReceipt.new(id: id, date: pay_date - 14, amount: 500, database: database).execute
      Comissioned::AddSalesReceipt.new(id: id, date: pay_date + 14, amount: 500, database: database).execute

      payday = CreatePaychecks.new(pay_date, database)
      payday.execute
      validate_commissioned_paycheck(payday, id, pay_date, 1000 + (500 + 300) * 10 / 100)
    end

    it 'should not pay a commissioned employee on wrong date' do
      id = 24
      Comissioned::AddEmployee.new(id: id, name: 'Bill', address: 'Home', salary: 1000.0, rate: 2.5, database: database).execute

      pay_date = Date.new(2001, 11, 23)
      payday = CreatePaychecks.new(pay_date, database)
      payday.execute
      payday.get_paycheck(id).must_be_nil
    end
  end

  describe 'Union' do
    it 'should deduct service charges from member' do
      id = 25
      Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.24, database: database).execute

      member_id = 777
      Union::Affiliate.new(id: id, member_id: member_id, dues: 9.42, database: database).execute

      pay_date = Date.new(2001, 11, 9)
      Union::AddServiceCharge.new(member_id: member_id, date: pay_date, charge: 19.42, database: database).execute

      Hourly::AddTimeCard.new(date: pay_date, hours: 8.0, id: id, database: database).execute

      payday = CreatePaychecks.new(pay_date, database)
      payday.execute

      pay_check = payday.get_paycheck(id)
      pay_check.wont_be_nil
      pay_check.pay_date.must_equal pay_date
      pay_check.gross_pay.must_be_close_to 8 * 15.24, 0.001
      pay_check.disposition.must_equal 'Hold'
      pay_check.deductions.must_be_close_to 9.42 + 19.42, 0.001
    end

    it 'should deduct service charges correct when spanning multiple pay periods' do
      id = 26
      Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.25, database: database).execute

      member_id = 778
      Union::Affiliate.new(id: id, member_id: member_id, dues: 9.42, database: database).execute

      pay_date = Date.new(2001, 11, 9)
      early_date = pay_date - 7
      late_date = pay_date + 7
      Union::AddServiceCharge.new(member_id: member_id, date: pay_date, charge: 19.42, database: database).execute
      Union::AddServiceCharge.new(member_id: member_id, date: early_date, charge: 100.00, database: database).execute
      Union::AddServiceCharge.new(member_id: member_id, date: late_date, charge: 200.00, database: database).execute

      Hourly::AddTimeCard.new(date: pay_date, hours: 8.0, id: id, database: database).execute

      payday = CreatePaychecks.new(pay_date, database)
      payday.execute

      pay_check = payday.get_paycheck(id)
      pay_check.wont_be_nil
      pay_check.gross_pay.must_be_close_to 8.0 * 15.25, 0.001
      pay_check.deductions.must_be_close_to 9.42 + 19.42, 0.001
      pay_check.net_pay.must_be_close_to 8.0 * 15.25 - 9.42 - 19.42, 0.001
    end
  end

  def validate_hourly_paycheck(payday, id, pay_date, pay)
    validate_paycheck(payday, id, pay_date, pay)
  end

  def validate_commissioned_paycheck(payday, id, pay_date, pay)
    validate_hourly_paycheck(payday, id, pay_date, pay)
  end

  def validate_paycheck(payday, id, pay_date, pay)
    pay_check = payday.get_paycheck(id)
    pay_check.wont_be_nil
    pay_check.pay_date.must_equal pay_date
    pay_check.gross_pay.must_be_close_to pay, 0.001
    pay_check.disposition.must_equal 'Hold'
    pay_check.deductions.must_be_close_to 0.0, 0.001
    pay_check.net_pay.must_be_close_to pay, 0.001
  end
end
