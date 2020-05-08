# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../delete_employee'
require_relative '../add_commissioned_employee'
require_relative '../payroll_database'

describe DeleteEmployee do
  it 'should delete a previously created employee' do
    emp_id = 4
    database = PayrollDatabase.new
    t = AddCommissionedEmployee.new(emp_id, 'Bill', 'Home', 2500, 3.2, database)
    t.execute

    e = database.get_employee(emp_id)
    e.wont_be_nil

    dt = DeleteEmployee.new(emp_id, database)
    dt.execute

    e = database.get_employee(emp_id)
    e.must_be_nil
  end
end
