# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../test/test_helper'
require_relative '../comissioned/add_employee'
require_relative '../weekly_schedule'
require_relative '../payroll_database'
require_relative 'classification'
require_relative 'change_classification'

describe Hourly::ChangeClassification do
  it 'should change an employees classification to hourly' do
    id = 9
    database = PayrollDatabase.new
    operation = Comissioned::AddEmployee.new(id: id, name: 'Bill', address: 'Home', salary: 1000, rate: 3.0, database: database)
    operation.execute

    operation = Hourly::ChangeClassification.new(id: id, rate: 15.25, database: database)
    operation.execute

    employee = database.employee(id)
    employee.wont_be_nil

    pay_check = employee.classification
    pay_check.wont_be_nil
    pay_check.must_be_kind_of Hourly::Classification
    pay_check.rate.must_be_close_to 15.25, 0.001

    ps = employee.schedule
    ps.must_be_kind_of WeeklySchedule
  end
  # TODO: add more test
  #
  # for checking that the old payment time works well and the new classification also works.
end
