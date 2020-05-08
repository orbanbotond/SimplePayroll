# frozen_string_literal: true

require 'minitest/autorun'

require_relative 'test_helper'
require_relative '../add_service_charge'
require_relative '../add_hourly_employee'
require_relative '../change_union_member'
require_relative '../payroll_database'
require 'date'

describe AddServiceCharge do
  it 'should create a service for an employee' do
    emp_id = 7
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(emp_id, 'Bill', 'Home', 15.25, database)
    t.execute

    e = database.get_employee(emp_id)
    e.wont_be_nil

    member_id = 86
    ChangeUnionMember.new(emp_id, member_id, 10.0, database).execute

    sct = AddServiceCharge.new(member_id, Date.new(2005, 8, 8), 12.95, database)
    sct.execute

    sc = e.affiliation.get_service_charge(Date.new(2005, 8, 8))
    sc.wont_be_nil
    sc.charge.must_be_close_to 12.95
    sc.date.must_equal Date.new(2005, 8, 8)
  end
end
