require_relative "add_employee"
require_relative "hourly_classification"
require_relative "weekly_schedule"

class AddHourlyEmployee < AddEmployee
  def initialize(id, name, address, rate)
    super(id, name, address)
    @rate = rate
  end

  def make_classification
    HourlyClassification.new(@rate)
  end

  def make_schedule
    WeeklySchedule.new
  end
end
