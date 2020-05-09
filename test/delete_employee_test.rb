# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../payroll_database'
require_relative '../hourly/add_employee'
require_relative '../delete_employee'

describe DeleteEmployee do
  it 'should delete a previously created employee' do
    id = 4
    database = PayrollDatabase.new
    Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Work', rate: 20.0, database: database).execute

    DeleteEmployee.new(id: id, database: database).execute

    employee = database.employee(id)
    employee.must_be_nil
  end
end
