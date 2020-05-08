# frozen_string_literal: true

require_relative 'hold_method'
require_relative 'employee'

# Business Logic Which Adds an Employee into the system
class AddEmployee
  attr_reader :name, :emp_id, :address, :database

  def initialize(emp_id, name, address, database)
    @database = database
    @emp_id = emp_id
    @name = name
    @address = address
  end

  def execute
    pay_check = make_classification
    ps = make_schedule
    pm = HoldMethod.new

    e = Employee.new(emp_id, name, address)
    e.classification = pay_check
    e.schedule = ps
    e.payment_method = pm

    database.add_employee(emp_id, e)
  end
end
