# frozen_string_literal: true

require File.join(Dir.getwd, 'test_helper')

describe Classifications::Comissioned::Operations::AddEmployee do
  it 'should create a commissioned employee' do
    emp_id = 3
    database = PayrollDatabase.new
    params = { id: emp_id,
               name: 'Jim',
               address: 'Garden',
               salary: 500.0,
               rate: 100.0,
               database: database }
    Classifications::Comissioned::Operations::AddEmployee.new(params).execute

    e = database.employee(emp_id)
    e.name.must_equal 'Jim'
    e.address.must_equal 'Garden'

    pay_check = e.classification
    pay_check.must_be_kind_of Classifications::Comissioned::Classification
    pay_check.salary.must_be_close_to 500.0, 0.0001
    pay_check.rate.must_be_close_to 100.0, 0.0001

    ps = e.schedule
    ps.must_be_kind_of Schedules::Biweekly

    pm = e.payment_method
    pm.must_be_kind_of PaymentMethods::Hold
  end
end
