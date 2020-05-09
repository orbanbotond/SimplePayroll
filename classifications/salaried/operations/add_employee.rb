# frozen_string_literal: true

require 'add_employee'
# TODO: the weekly schedule is s bit dubious why is it hardcoded here.
require 'monthly_schedule'
require_relative '../classification'

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
