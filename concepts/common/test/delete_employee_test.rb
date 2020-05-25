# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Operations::DeleteEmployee do
  include DatabaseCleanerSupport

  it 'should delete a previously created employee' do
    id = 5
    database = Relational::PostgresqlDatabase.new
    Classifications::Hourly::Operations::AddEmployee.new(id: id, name: 'Bill', address: 'Work', rate: 20.0, database: database).execute
    Operations::DeleteEmployee.new(id: id, database: database).execute

    employee = database.employee(id)
    _(employee).must_be_nil
  end
end
