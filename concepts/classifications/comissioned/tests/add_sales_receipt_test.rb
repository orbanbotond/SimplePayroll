# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Classifications::Comissioned::Operations::AddSalesReceipt do
  include DatabaseCleanerSupport

  it 'should add a sales receipt to an employee' do
    id = 6
    database = Relational::PostgresqlDatabase.new
    params = { id: id,
               name: 'Jim',
               address: 'Garden',
               salary: 500.0,
               rate: 100.0,
               database: database }
    Classifications::Comissioned::Operations::AddEmployee.new(params).execute

    Classifications::Comissioned::Operations::AddSalesReceipt.new(id: id, date: Date.new(2005, 3, 30), amount: 500, database: database).execute

    employee = database.employee(id)
    employee.wont_be_nil

    classification = employee.classification
    classification.must_be_kind_of Classifications::Comissioned::Classification

    receipts = classification.sales_receipts
    receipts.first.amount.must_equal 500
    receipts.first.date.must_equal Date.new(2005, 3, 30)
  end
end
