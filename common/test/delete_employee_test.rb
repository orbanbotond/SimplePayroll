# frozen_string_literal: true

require 'minitest/autorun'
require File.join(Dir.getwd, 'test_helper')
require 'payroll_database'
require 'hourly/operations/add_employee'
require 'operations/delete_employee'

describe DeleteEmployee do
  it 'should delete a previously created employee' do
    id = 5
    database = PayrollDatabase.instance
    Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Work', rate: 20.0, database: database).execute
    DeleteEmployee.new(id: id, database: database).execute

    employee = database.employee(id)
    employee.must_be_nil
  end
end
