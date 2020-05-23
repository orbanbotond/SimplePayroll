# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Classifications::Hourly::Operations::Change do
  include DatabaseCleanerSupport

  it 'should change an employees classifications to hourly' do
    id = 9
    database =  Relational::PostgresqlDatabase.new
    operation = Classifications::Comissioned::Operations::AddEmployee.new(id: id, name: 'Bill', address: 'Home', salary: 1000, rate: 3.0, database: database)
    operation.execute

    operation = Classifications::Hourly::Operations::Change.new(id: id, rate: 15.25, database: database)
    operation.execute

    employee = database.employee(id)
    employee.wont_be_nil

    pay_check = employee.classification
    pay_check.wont_be_nil
    pay_check.must_be_kind_of Classifications::Hourly::Classification
    pay_check.rate.must_be_close_to 15.25, 0.001

    ps = employee.schedule
    ps.must_be_kind_of Schedules::Weekly
  end
  # TODO: add more tests
  #
  # for checking that the old payment time works well and the new classifications also works.
end
