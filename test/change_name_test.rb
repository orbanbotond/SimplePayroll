# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../change_name'
require_relative '../add_hourly_employee'
require_relative '../payroll_database'

describe ChangeName do
  it 'should change the name of an employee' do
    emp_id = 2
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(emp_id, 'Bill', 'Home', 15.25, database)
    t.execute

    cnt = ChangeName.new(emp_id, 'Bob', database)
    cnt.execute

    e = database.get_employee(emp_id)
    e.wont_be_nil
    e.name.must_equal 'Bob'
  end
end
