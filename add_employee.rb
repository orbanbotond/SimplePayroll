require_relative "hold_method"
require_relative "employee"

class AddEmployee
  attr_reader :name, :empid, :address, :database

  def initialize(empid, name, address, database)
    @database = database
    @empid = empid
    @name = name
    @address = address
  end

  def execute
    pc = make_classification
    ps = make_schedule
    pm = HoldMethod.new

    e = Employee.new(empid, name, address)
    e.classification = pc
    e.schedule = ps
    e.payment_method = pm

    database.add_employee(empid, e)
  end
end
