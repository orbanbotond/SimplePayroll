# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Classifications::Hourly::Operations::AddTimeCard do
  include DatabaseCleanerSupport

  it 'should add a timecard to an employee' do
    id = 5
    database = Relational::PostgresqlDatabase.new
    operation = Classifications::Hourly::Operations::AddEmployee.new(id: id, name: 'Bill', address: 'Home', rate: 15.25, database: database)
    operation.execute

    operation = Classifications::Hourly::Operations::AddTimeCard.new(date: Date.new(2005, 7, 31), hours: 8.0, id: id, database: database)
    operation.execute

    operation = Classifications::Hourly::Operations::AddTimeCard.new(date: Date.new(2005, 7, 30), hours: 7.0, id: id, database: database)
    operation.execute

    employee = database.employee(id)
    _(employee).wont_be_nil

    classification = employee.classification
    _(classification).must_be_kind_of Classifications::Hourly::Classification

    timecard = classification.time_card(Date.new(2005, 7, 31))
    _(timecard).wont_be_nil
    _(timecard.hours).must_equal 8.0
    _(timecard.date).must_equal Date.new(2005, 7, 31)

    timecard = classification.time_card(Date.new(2005, 7, 30))
    _(timecard).wont_be_nil
    _(timecard.hours).must_equal 7.0
    _(timecard.date).must_equal Date.new(2005, 7, 30)

    timecard = classification.time_card(Date.new(2005, 7, 29))
    _(timecard).must_be_nil
  end
end
