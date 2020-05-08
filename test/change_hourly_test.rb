# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../change_hourly'
require_relative '../add_commissioned_employee'
require_relative '../hourly_classification'
require_relative '../weekly_schedule'
require_relative '../payroll_database'

describe ChangeHourly do
  it 'should change an employees classification to hourly' do
    emp_id = 9
    database = PayrollDatabase.new
    t = AddCommissionedEmployee.new(emp_id, 'Bill', 'Home', 1000, 3.0, database)
    t.execute

    cht = ChangeHourly.new(emp_id, 15.25, database)
    cht.execute

    e = database.get_employee(emp_id)
    e.wont_be_nil

    pay_check = e.classification
    pay_check.wont_be_nil
    pay_check.must_be_kind_of HourlyClassification
    pay_check.rate.must_be_close_to 15.25, 0.001

    ps = e.schedule
    ps.must_be_kind_of WeeklySchedule
  end
  # TODO: add more test
  #
  # for checking that the old payment time works well and the new classification also works.
end
