# frozen_string_literal: true

require 'minitest/autorun'
require File.join(Dir.getwd, 'test_helper')
require 'payroll_database'
require 'hourly/operations/add_employee'
require 'hourly/operations/add_time_card'
require 'date'

describe Hourly::AddTimeCard do
  it 'should add a timecard to an employee' do
    id = 5
    database = PayrollDatabase.new
    operation = Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.25, database: database)
    operation.execute

    operation = Hourly::AddTimeCard.new(date: Date.new(2005, 7, 31), hours: 8.0, id: id, database: database)
    operation.execute

    operation = Hourly::AddTimeCard.new(date: Date.new(2005, 7, 30), hours: 7.0, id: id, database: database)
    operation.execute

    employee = database.employee(id)
    employee.wont_be_nil

    classification = employee.classification
    classification.must_be_kind_of Hourly::Classification

    timecard = classification.time_card(Date.new(2005, 7, 31))
    timecard.wont_be_nil
    timecard.hours.must_equal 8.0
    timecard.date.must_equal Date.new(2005, 7, 31)

    timecard = classification.time_card(Date.new(2005, 7, 30))
    timecard.wont_be_nil
    timecard.hours.must_equal 7.0
    timecard.date.must_equal Date.new(2005, 7, 30)

    timecard = classification.time_card(Date.new(2005, 7, 29))
    timecard.must_be_nil
  end
end
