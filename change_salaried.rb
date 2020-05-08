# frozen_string_literal: true

require_relative 'change_classification'
require_relative 'salaried_classification'
require_relative 'monthly_schedule'

# Business Logic Which Changes the Employee Classification to Salaried
class ChangeSalaried < ChangeClassification
  def initialize(emp_id, salary, database)
    super(emp_id, database)
    @salary = salary
  end

  def make_classification
    SalariedClassification.new(@salary)
  end

  def make_schedule
    MonthlySchedule.new
  end
end
