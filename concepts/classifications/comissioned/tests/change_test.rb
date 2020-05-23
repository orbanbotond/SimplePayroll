# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Classifications::Comissioned::Operations::Change do
  include DatabaseCleanerSupport

  it 'should change an employees payment classifications to commissioned' do
    employee_id = 11
    database = Relational::PostgresqlDatabase.new
    operation = Classifications::Hourly::Operations::AddEmployee.new(id: employee_id, name: 'Bob', address: 'Home', rate: 15.25, database: database)
    operation.execute
    operation = Classifications::Comissioned::Operations::Change.new(id: employee_id, salary: 1000, rate: 3.0, database: database)
    operation.execute

    employee = database.employee(employee_id)
    employee.wont_be_nil

    classification = employee.classification
    classification.wont_be_nil
    classification.must_be_kind_of Classifications::Comissioned::Classification
    classification.salary.must_be_close_to 1000.0, 0.001
    classification.rate.must_be_close_to 3.0, 0.001

    schedule = employee.schedule
    schedule.must_be_kind_of Schedules::Biweekly
  end
  # TODO: add more tests for checking the before after changes
  # check if the old classification stayed in place
  # check if the new classification is active
  # check that only the new classification is active
end
