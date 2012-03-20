require_relative "change_classification"
require_relative "commissioned_classification"
require_relative "biweekly_schedule"

class ChangeCommissioned < ChangeClassification
  def initialize(empId, salary, rate)
    super(empId)
    @salary = salary
    @rate = rate
  end

  def make_classification
    CommissionedClassification.new(@salary, @rate)
  end

  def make_schedule
    BiweeklySchedule.new
  end
end
