# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../change_salaried'
require_relative '../add_hourly_employee'
require_relative '../payroll_database'

describe ChangeSalaried do
  it 'should an employees payment classification to salaried' do
    emp_id = 10
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(emp_id, 'Bill', 'Home', 15.25, database)
    t.execute

    cst = ChangeSalaried.new(emp_id, 1500.0, database)
    cst.execute

    e = database.get_employee(emp_id)
    e.wont_be_nil

    pay_check = e.classification
    pay_check.wont_be_nil
    pay_check.must_be_kind_of SalariedClassification
    pay_check.salary.must_be_close_to 1500.0, 0.001

    ps = e.schedule
    ps.must_be_kind_of MonthlySchedule
  end
  # TODO: check that the old payment time works well and the new classification also works.
end
