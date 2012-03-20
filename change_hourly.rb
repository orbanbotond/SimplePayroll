require_relative "change_classification"

class ChangeHourly < ChangeClassification
  def initialize(empId, rate)
    super(empId)
    @rate = rate
  end

  def make_classification
    HourlyClassification.new(@rate)
  end

  def make_schedule
    WeeklySchedule.new
  end
end
