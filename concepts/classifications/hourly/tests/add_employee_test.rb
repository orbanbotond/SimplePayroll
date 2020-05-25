# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Classifications::Hourly::Operations::AddEmployee do
  include DatabaseCleanerSupport

  it 'should create an hourly employee' do
    id = 2
    database = Relational::PostgresqlDatabase.new

    t = Classifications::Hourly::Operations::AddEmployee.new(id: id, name: 'John', address: 'Work', rate: 20.0, database: database)
    t.execute

    e = database.employee(id)
    _(e.name).must_equal 'John'
    _(e.address).must_equal 'Work'

    pay_check = e.classification
    _(pay_check).must_be_kind_of Classifications::Hourly::Classification
    _(pay_check.rate).must_be_close_to 20.0, 0.0001

    ps = e.schedule
    _(ps).must_be_kind_of Schedules::Weekly

    pm = e.payment_method
    _(pm).must_be_kind_of PaymentMethods::Hold
  end
end
