# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Operations::DeleteEmployee do
  it 'should delete a previously created employee' do
    id = 5
    database = PayrollDatabase.instance
    Classifications::Hourly::Operations::AddEmployee.new(id: id, name: 'Bill', address: 'Work', rate: 20.0, database: database).execute
    Operations::DeleteEmployee.new(id: id, database: database).execute

    employee = database.employee(id)
    employee.must_be_nil
  end
end
