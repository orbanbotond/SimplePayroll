require "minitest/autorun"
require_relative "../change_hourly"
require_relative "../add_commissioned_employee"
require_relative "../hourly_classification"
require_relative "../weekly_schedule"
require_relative "../payroll_database"

describe ChangeHourly do
  it "should change an employees classification to hourly" do
    empId = 9
    database = PayrollDatabase.new
    t = AddCommissionedEmployee.new(empId, "Bill", "Home", 1000, 3.0, database)
    t.execute

    cht = ChangeHourly.new(empId, 15.25, database)
    cht.execute

    e = database.get_employee(empId)
    e.wont_be_nil

    pc = e.classification
    pc.wont_be_nil
    pc.must_be_kind_of HourlyClassification
    pc.rate.must_be_close_to 15.25, 0.001

    ps = e.schedule
    ps.must_be_kind_of WeeklySchedule
  end
  # TODO add more test for checking that the old payment time works well and the new classification also works.
end
