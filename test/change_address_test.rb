# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../change_address'
require_relative '../add_hourly_employee'
require_relative '../payroll_database'

describe ChangeAddress do
  it 'should change an employees address' do
    emp_id = 8
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(emp_id, 'Bill', 'Work', 20.0, database)
    t.execute

    cat = ChangeAddress.new(emp_id, 'Home', database)
    cat.execute

    e = database.get_employee(emp_id)
    e.wont_be_nil
    e.address.must_equal 'Home'
  end
end
