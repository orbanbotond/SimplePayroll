# frozen_string_literal: true

require 'minitest/autorun'

require_relative 'test_helper'
require_relative '../add_hourly_employee'
require_relative '../payroll_database'

describe AddHourlyEmployee do
  it 'should create an hourly employee' do
    emp_id = 2
    database = PayrollDatabase.new

    t = AddHourlyEmployee.new(emp_id, 'John', 'Work', 20.0, database)
    t.execute

    e = database.get_employee(emp_id)
    e.name.must_equal 'John'
    e.address.must_equal 'Work'

    pay_check = e.classification
    pay_check.must_be_kind_of HourlyClassification
    pay_check.rate.must_be_close_to 20.0, 0.0001

    ps = e.schedule
    ps.must_be_kind_of WeeklySchedule

    pm = e.payment_method
    pm.must_be_kind_of HoldMethod
  end
end
