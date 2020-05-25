# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Classifications::Salaried::Operations::AddEmployee do
  include DatabaseCleanerSupport

  it 'should create a salaried employee' do
    id = 1
    database =  Relational::PostgresqlDatabase.new
    operation = Classifications::Salaried::Operations::AddEmployee.new(id: id, name: 'Bob', address: 'Home', salary: 1100.00, database: database)
    operation.execute
    employee = database.employee(id)
    _(employee.name).must_equal 'Bob'
    _(employee.address).must_equal 'Home'

    pay_check = employee.classification
    _(pay_check).must_be_kind_of Classifications::Salaried::Classification
    _(pay_check.salary).must_be_close_to 1100, 0.001

    schedule = employee.schedule
    _(schedule).must_be_kind_of Schedules::Monthly

    payment_method = employee.payment_method
    _(payment_method).must_be_kind_of PaymentMethods::Hold
  end
end
