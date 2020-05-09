# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../payroll_database'
require_relative '../hourly/add_employee'
require_relative '../change_address'

describe ChangeAddress do
  it 'should change an employees address' do
    id = 8
    database = PayrollDatabase.new
    Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Work', rate: 20.0, database: database).execute

    ChangeAddress.new(id: id, address: 'Home', database: database).execute

    employee = database.employee(id)
    employee.wont_be_nil
    employee.address.must_equal 'Home'
  end
end
