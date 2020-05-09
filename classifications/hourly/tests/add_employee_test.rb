# frozen_string_literal: true

require 'minitest/autorun'
require File.join(Dir.getwd, 'test_helper')
require 'payroll_database'
require 'hourly/operations/add_employee'

describe Hourly::AddEmployee do
  it 'should create an hourly employee' do
    id = 2
    database = PayrollDatabase.new

    t = Hourly::AddEmployee.new(id: id, name: 'John', address: 'Work', rate: 20.0, database: database)
    t.execute

    e = database.employee(id)
    e.name.must_equal 'John'
    e.address.must_equal 'Work'

    pay_check = e.classification
    pay_check.must_be_kind_of Hourly::Classification
    pay_check.rate.must_be_close_to 20.0, 0.0001

    ps = e.schedule
    ps.must_be_kind_of WeeklySchedule

    pm = e.payment_method
    pm.must_be_kind_of HoldMethod
  end
end
