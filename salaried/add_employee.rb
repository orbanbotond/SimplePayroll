# frozen_string_literal: true

require_relative '../add_employee'
require_relative '../employee'
require_relative '../monthly_schedule'
require_relative '../hold_method'
require_relative 'classification'

# Business Logic Which Adds a SalariedEmployee into the system
module Salaried
  AddEmployee = ImmutableStruct.new(:id, :name, :address, :salary, :database) do
    include ::AddEmployee

    def make_classification
      Classification.new(salary: salary)
    end

    def make_schedule
      MonthlySchedule.new
    end
  end
end
