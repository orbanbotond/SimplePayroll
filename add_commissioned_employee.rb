require_relative "add_employee"
require_relative "commissioned_classification"
require_relative "biweekly_schedule"

class AddCommissionedEmployee < AddEmployee
  def initialize(id, name, address, salary, rate, database)
    super(id, name, address, database)
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
