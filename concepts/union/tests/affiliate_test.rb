# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Union::Operations::Affiliate do
  include DatabaseCleanerSupport

  it 'should change an employee to have a union affiliation' do
    id = 12
    database = Relational::PostgresqlDatabase.new
    operation = Classifications::Hourly::Operations::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 2.5, database: database)
    operation.execute

    member_id = 7743
    operation = Union::Operations::Affiliate.new(id: id, member_id: member_id, dues: 99.42, database: database)
    operation.execute

    employee = database.employee(id)

    affiliation = employee.affiliation
    affiliation.wont_be_nil
    affiliation.must_be_kind_of Union::Affiliation

    affiliation.dues.must_be_close_to 99.42, 0.001

    member = database.union_member(member_id)
    member.wont_be_nil
    member.id.must_equal employee.id
  end
end
