# frozen_string_literal: true

require 'minitest/autorun'
require File.join(Dir.getwd, 'test_helper')
require 'payroll_database'
require 'hourly/operations/add_employee'
require 'operations/change_name'

describe ChangeName do
  it 'should change the name of an employee' do
    id = 2
    database = PayrollDatabase.new
    Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Work', rate: 20.0, database: database).execute

    ChangeName.new(id: id, name: 'Bob', database: database).execute

    employee = database.employee(id)
    employee.wont_be_nil
    employee.name.must_equal 'Bob'
  end
end
