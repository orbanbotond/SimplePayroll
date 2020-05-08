# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../add_commissioned_employee'
require_relative '../payroll_database'

describe AddCommissionedEmployee do
  it 'should create a commissioned employee' do
    emp_id = 3
    database = PayrollDatabase.new
    t = AddCommissionedEmployee.new(emp_id, 'Jim', 'Garden', 500.0, 100.0, database)
    t.execute

    e = database.get_employee(emp_id)
    e.name.must_equal 'Jim'
    e.address.must_equal 'Garden'

    pay_check = e.classification
    pay_check.must_be_kind_of CommissionedClassification
    pay_check.salary.must_be_close_to 500.0, 0.0001
    pay_check.rate.must_be_close_to 100.0, 0.0001

    ps = e.schedule
    ps.must_be_kind_of BiweeklySchedule

    pm = e.payment_method
    pm.must_be_kind_of HoldMethod
  end
end
