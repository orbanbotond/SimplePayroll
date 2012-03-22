require_relative "change_employee"

class ChangeClassification < ChangeEmployee
  def initialize(empId, database)
    super(empId, database)
  end

  def change(employee)
    employee.classification = make_classification
    employee.schedule = make_schedule
  end
end
