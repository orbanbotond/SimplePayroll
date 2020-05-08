# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../change_commissioned'
require_relative '../add_hourly_employee'
require_relative '../payroll_database'

describe ChangeCommissioned do
  it 'should change an employees payment classification to commissioned' do
    emp_id = 11
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(emp_id, 'Bob', 'Home', 15.25, database)
    t.execute

    cct = ChangeCommissioned.new(emp_id, 1000, 3.0, database)
    cct.execute

    e = database.get_employee(emp_id)
    e.wont_be_nil

    pay_check = e.classification
    pay_check.wont_be_nil
    pay_check.must_be_kind_of CommissionedClassification
    pay_check.salary.must_be_close_to 1000.0, 0.001
    pay_check.rate.must_be_close_to 3.0, 0.001

    ps = e.schedule
    ps.must_be_kind_of BiweeklySchedule
  end
  # TODO: add more test for checking the before after changes
end
