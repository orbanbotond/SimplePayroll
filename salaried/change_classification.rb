# frozen_string_literal: true

require_relative '../change_classification'
require_relative '../monthly_schedule'
require_relative 'classification'

# Business Logic Which Changes the Employee Classification to Salaried
module Salaried
  ChangeClassification = ImmutableStruct.new(:id, :salary, :database) do
    include ::ChangeClassification

    def make_classification
      Classification.new(salary: salary)
    end

    def make_schedule
      MonthlySchedule.new
    end
  end
end
