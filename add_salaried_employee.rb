require_relative "add_employee"
require_relative "employee"
require_relative "salaried_classification"
require_relative "monthly_schedule"
require_relative "hold_method"

class AddSalariedEmployee < AddEmployee
  def initialize(id, name, address, salary)
    super(id, name, address)
    @salary = salary
  end

  def make_classification
    SalariedClassification.new(@salary)
  end

  def make_schedule
    MonthlySchedule.new
  end
end
