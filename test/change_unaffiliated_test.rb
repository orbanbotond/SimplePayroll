# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../change_union_member'
require_relative '../add_hourly_employee'
require_relative '../change_unaffiliated'
require_relative '../no_affiliation'
require_relative '../payroll_database'

describe ChangeUnionMember do
  it 'should change an employee to have a union affiliation' do
    emp_id = 12
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(emp_id, 'Bill', 'Home', 1500, database)
    t.execute

    member_id = 7743
    cut = ChangeUnionMember.new(emp_id, member_id, 99.42, database)
    cut.execute

    e = database.get_employee(emp_id)
    e.wont_be_nil

    operation = ChangeUnaffiliated.new(emp_id, database)
    operation.execute

    aaf = e.affiliation
    aaf.must_be_kind_of NoAffiliation

    member = database.union_member(member_id)
    member.must_be_nil
  end
end
