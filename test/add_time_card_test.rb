# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../payroll_database'
require_relative '../add_time_card'
require_relative '../add_hourly_employee'
require 'date'

describe AddTimeCard do
  it 'should add a timecard to an employee' do
    emp_id = 5
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(emp_id, 'Bill', 'Home', 15.25, database)
    t.execute

    tct = AddTimeCard.new(Date.new(2005, 7, 31), 8.0, emp_id, database)
    tct.execute

    e = database.get_employee(emp_id)
    e.wont_be_nil

    pay_check = e.classification
    pay_check.must_be_kind_of HourlyClassification

    tc = pay_check.get_time_card(Date.new(2005, 7, 31))
    tc.wont_be_nil
    tc.hours.must_equal 8.0
    tc.date.must_equal Date.new(2005, 7, 31)
  end
  # TODO: add negative tests.
end
