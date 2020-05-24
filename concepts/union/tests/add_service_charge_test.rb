# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Union::Operations::AddServiceCharge do
  include DatabaseCleanerSupport

  it 'should create a service for an employee' do
    id = 7
    database =  Relational::PostgresqlDatabase.new
    Classifications::Hourly::Operations::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.25, database: database).execute

    member_id = 86
    Union::Operations::Affiliate.new(id: id, member_id: member_id, dues: 10.0, database: database).execute

    Union::Operations::AddServiceCharge.new(member_id: member_id, date: Date.new(2005, 8, 8), charge: 12.95, database: database).execute
    Union::Operations::AddServiceCharge.new(member_id: member_id, date: Date.new(2005, 8, 3), charge: 9.95, database: database).execute

    employee = database.employee(id)
    service_charge = employee.affiliation.service_charge(Time.new(2005, 8, 8))
    service_charge.wont_be_nil
    service_charge.charge.must_be_close_to 12.95
    service_charge.date.must_equal Time.new(2005, 8, 8)
    service_charge = employee.affiliation.service_charge(Time.new(2005, 8, 3))
    service_charge.wont_be_nil
    service_charge.charge.must_be_close_to 9.95
    service_charge.date.must_equal Time.new(2005, 8, 3)
    service_charge = employee.affiliation.service_charge(Time.new(2005, 8, 2))
    service_charge.must_be_nil
  end
end
