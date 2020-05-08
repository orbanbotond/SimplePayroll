# frozen_string_literal: true

require_relative 'change_classification'
require_relative 'commissioned_classification'
require_relative 'biweekly_schedule'

# Business Logic Which Changes the Employee Classification to Commissioned
class ChangeCommissioned < ChangeClassification
  def initialize(emp_id, salary, rate, database)
    super(emp_id, database)
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
