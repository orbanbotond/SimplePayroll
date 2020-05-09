# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../test/test_helper'
require_relative '../payroll_database'
require_relative 'add_employee'
require_relative 'add_sales_receipt'
require_relative 'classification'
require 'date'

describe Comissioned::AddSalesReceipt do
  it 'should add a sales receipt to an employee' do
    id = 6
    database = PayrollDatabase.new
    params = { id: id,
               name: 'Jim',
               address: 'Garden',
               salary: 500.0,
               rate: 100.0,
               database: database }
    Comissioned::AddEmployee.new(params).execute

    Comissioned::AddSalesReceipt.new(id: id, date: Date.new(2005, 3, 30), amount: 500, database: database).execute

    employee = database.employee(id)
    employee.wont_be_nil

    pay_check = employee.classification
    pay_check.must_be_kind_of Comissioned::Classification

    srs = pay_check.sales_receipts
    srs.first.amount.must_equal 500
    srs.first.date.must_equal Date.new(2005, 3, 30)
  end
end
