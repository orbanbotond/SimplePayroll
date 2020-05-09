# frozen_string_literal: true

require 'minitest/autorun'

require 'minitest/autorun'
require File.join(Dir.getwd, 'test_helper')
require 'payroll_database'
require 'hourly/operations/add_employee'
require 'operations/affiliate'
require 'operations/add_service_charge'
require 'date'

describe Union::AddServiceCharge do
  it 'should create a service for an employee' do
    id = 7
    database = PayrollDatabase.new
    Hourly::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.25, database: database).execute

    member_id = 86
    Union::Affiliate.new(id: id, member_id: member_id, dues: 10.0, database: database).execute

    Union::AddServiceCharge.new(member_id: member_id, date: Date.new(2005, 8, 8), charge: 12.95, database: database).execute
    Union::AddServiceCharge.new(member_id: member_id, date: Date.new(2005, 8, 3), charge: 9.95, database: database).execute

    employee = database.employee(id)
    service_charge = employee.affiliation.service_charge(Date.new(2005, 8, 8))
    service_charge.wont_be_nil
    service_charge.charge.must_be_close_to 12.95
    service_charge.date.must_equal Date.new(2005, 8, 8)
    service_charge = employee.affiliation.service_charge(Date.new(2005, 8, 3))
    service_charge.wont_be_nil
    service_charge.charge.must_be_close_to 9.95
    service_charge.date.must_equal Date.new(2005, 8, 3)
    service_charge = employee.affiliation.service_charge(Date.new(2005, 8, 2))
    service_charge.must_be_nil
  end
end
