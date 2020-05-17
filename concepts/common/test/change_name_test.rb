# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Operations::ChangeName do
  include DatabaseCleanerSupport

  it 'should change the name of an employee' do
    id = 2
    database = Relational::PostgresqlDatabase.new
    Classifications::Hourly::Operations::AddEmployee.new(id: id, name: 'Bill', address: 'Work', rate: 20.0, database: database).execute

    Operations::ChangeName.new(id: id, name: 'Bob', database: database).execute

    employee = database.employee(id)
    employee.wont_be_nil
    employee.name.must_equal 'Bob'
  end
end
