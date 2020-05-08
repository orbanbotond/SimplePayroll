# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'test_helper'
require_relative '../add_sales_receipt'
require_relative '../add_commissioned_employee'
require_relative '../payroll_database'
require 'date'

describe AddSalesReceipt do
  it 'should add a sales receipt to an employee' do
    emp_id = 6
    database = PayrollDatabase.new
    t = AddCommissionedEmployee.new(emp_id, 'John', 'Home', 1500, 2.5, database)
    t.execute

    srt = AddSalesReceipt.new(emp_id, Date.new(2005, 3, 30), 500, database)
    srt.execute

    e = database.get_employee(emp_id)
    e.wont_be_nil

    pay_check = e.classification
    pay_check.must_be_kind_of CommissionedClassification

    srs = pay_check.sales_receipts
    srs.first.amount.must_equal 500
    srs.first.date.must_equal Date.new(2005, 3, 30)
  end
end
