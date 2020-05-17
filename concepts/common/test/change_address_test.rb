# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Operations::ChangeAddress do
  it 'should change an employees address' do
    id = 8
    database = PayrollDatabase.new
    Classifications::Hourly::Operations::AddEmployee.new(id: id, name: 'Bill', address: 'Work', rate: 20.0, database: database).execute

    Operations::ChangeAddress.new(id: id, address: 'Home', database: database).execute

    employee = database.employee(id)
    employee.wont_be_nil
    employee.address.must_equal 'Home'
  end
end
