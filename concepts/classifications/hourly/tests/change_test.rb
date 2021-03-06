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
    _(employee).wont_be_nil

    pay_check = employee.classification
    _(pay_check).wont_be_nil
    _(pay_check).must_be_kind_of Classifications::Hourly::Classification
    _(pay_check.rate).must_be_close_to 15.25, 0.001

    ps = employee.schedule
    _(ps).must_be_kind_of Schedules::Weekly
  end
  # TODO: add more tests
  # One hypothetical scenario would be to block the change if there are time sheets submitted
  # or to keep the old then add for the next billing cycle
  # for checking that the old payment time works well and the new classifications also works.
end
