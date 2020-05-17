# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Union::Operations::UnAffiliate do
  it 'should change an employee to have a union affiliation' do
    id = 12
    database = PayrollDatabase.new
    Classifications::Hourly::Operations::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 2.5, database: database).execute

    member_id = 7743
    Union::Operations::Affiliate.new(id: id, member_id: member_id, dues: 99.42, database: database).execute

    employee = database.employee(id)

    Union::Operations::UnAffiliate.new(id: id, database: database).execute

    affiliation = employee.affiliation
    affiliation.must_be_kind_of Union::NoAffiliation

    member = database.union_member(member_id)
    member.must_be_nil
  end
end
