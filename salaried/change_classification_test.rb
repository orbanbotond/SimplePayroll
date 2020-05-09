# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../test/test_helper'
require_relative '../payroll_database'
require_relative '../hourly/add_employee'
require_relative '../monthly_schedule'
require_relative 'change_classification'
require_relative 'classification'

describe Salaried::ChangeClassification do
  it 'should an employees payment classification to salaried' do
    id = 10
    database = PayrollDatabase.new
    operation = Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.25, database: database)
    operation.execute

    operation = Salaried::ChangeClassification.new(id: id, salary: 1500.0, database: database)
    operation.execute

    employee = database.employee(id)
    employee.wont_be_nil

    pay_check = employee.classification
    pay_check.wont_be_nil
    pay_check.must_be_kind_of Salaried::Classification
    pay_check.salary.must_be_close_to 1500.0, 0.001

    payment_schedule = employee.schedule
    payment_schedule.must_be_kind_of MonthlySchedule
  end
  # TODO: check that the old payment time works well and the new classification also works.
end
