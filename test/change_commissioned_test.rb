require "minitest/autorun"
require_relative "../change_commissioned"
require_relative "../add_hourly_employee"
require_relative "../payroll_database"

describe ChangeCommissioned do
  it "should change an employees payment classification to commissioned" do
    empId = 11
    database = PayrollDatabase.new
    t = AddHourlyEmployee.new(empId, "Bob", "Home", 15.25, database)
    t.execute

    cct = ChangeCommissioned.new(empId, 1000, 3.0, database)
    cct.execute

    e = database.get_employee(empId)
    e.wont_be_nil

    pc = e.classification
    pc.wont_be_nil
    pc.must_be_kind_of CommissionedClassification
    pc.salary.must_be_close_to 1000.0, 0.001
    pc.rate.must_be_close_to 3.0, 0.001

    ps = e.schedule
    ps.must_be_kind_of BiweeklySchedule
  end
  # TODO add more test for checking the before after changes
end
