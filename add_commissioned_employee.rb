# frozen_string_literal: true

require_relative 'add_employee'
require_relative 'commissioned_classification'
require_relative 'biweekly_schedule'

# Business Logic Which Adds a Commissioned Employee
class AddCommissionedEmployee < AddEmployee
  # rubocop:disable Metrics/ParameterLists
  def initialize(id, name, address, salary, rate, database)
    super(id, name, address, database)
    @salary = salary
    @rate = rate
  end

  def make_classification
    CommissionedClassification.new(@salary, @rate)
  end

  # @todo why biweekly? should that aspect be independent of the commissions?
  # this seems like a hard wired rule
  def make_schedule
    BiweeklySchedule.new
  end
end
