require "minitest/autorun"
require_relative "../delete_employee"
require_relative "../add_commissioned_employee"

describe DeleteEmployee do
  it "should delete a previously created employee" do
    empId = 4
    database = PayrollDatabase.new
    t = AddCommissionedEmployee.new(empId, "Bill", "Home", 2500, 3.2, database)
    t.execute

    e = database.get_employee(empId)
    e.wont_be_nil

    dt = DeleteEmployee.new(empId, database)
    dt.execute

    e = database.get_employee(empId)
    e.must_be_nil
  end
end
