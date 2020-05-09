# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../test/test_helper'
require_relative '../payroll_database'
require_relative '../monthly_schedule'
require_relative '../hold_method'
require_relative 'add_employee'
require_relative 'classification'

describe Salaried::AddEmployee do
  it 'should create a salaried employee' do
    id = 1
    database = PayrollDatabase.new
    operation = Salaried::AddEmployee.new(id: id, name: 'Bob', address: 'Home', salary: 1100.00, database: database)
    operation.execute
    employee = database.employee(id)
    employee.name.must_equal 'Bob'
    employee.address.must_equal 'Home'

    pay_check = employee.classification
    pay_check.must_be_kind_of Salaried::Classification
    pay_check.salary.must_be_close_to 1100, 0.001

    schedule = employee.schedule
    schedule.must_be_kind_of MonthlySchedule

    payment_method = employee.payment_method
    payment_method.must_be_kind_of HoldMethod
  end
end
