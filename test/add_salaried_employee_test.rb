# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../add_salaried_employee'
require_relative '../payroll_database'

describe AddSalariedEmployee do
  it 'should create a salaried employee' do
    emp_id = 1
    database = PayrollDatabase.new
    t = AddSalariedEmployee.new(emp_id, 'Bob', 'Home', 1100.00, database)
    t.execute

    e = database.get_employee(emp_id)
    e.name.must_equal 'Bob'
    e.address.must_equal 'Home'

    pay_check = e.classification
    pay_check.must_be_kind_of SalariedClassification
    pay_check.salary.must_be_close_to 1100, 0.001

    ps = e.schedule
    ps.must_be_kind_of MonthlySchedule

    pm = e.payment_method
    pm.must_be_kind_of HoldMethod
  end
end
