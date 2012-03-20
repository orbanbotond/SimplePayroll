require_relative "change_classification"
require_relative "salaried_classification"
require_relative "monthly_schedule"

class ChangeSalaried < ChangeClassification
  def initialize(empId, salary)
    super(empId)
    @salary = salary
  end

  def make_classification
    SalariedClassification.new(@salary)
  end

  def make_schedule
    MonthlySchedule.new
  end
end
