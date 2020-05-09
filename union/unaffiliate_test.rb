# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../test/test_helper'
require_relative '../payroll_database'
require_relative '../hourly/add_employee'
require_relative 'affiliate'
require_relative 'unaffiliate'
require_relative 'no_affiliation'

describe Union::Affiliate do
  it 'should change an employee to have a union affiliation' do
    id = 12
    database = PayrollDatabase.new
    Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 2.5, database: database).execute

    member_id = 7743
    Union::Affiliate.new(id: id, member_id: member_id, dues: 99.42, database: database).execute

    employee = database.employee(id)

    Union::UnAffiliate.new(id: id, database: database).execute

    affiliation = employee.affiliation
    affiliation.must_be_kind_of NoAffiliation

    member = database.union_member(member_id)
    member.must_be_nil
  end
end
