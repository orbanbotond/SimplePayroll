# frozen_string_literal: true

require_relative '../change_classification'
require_relative '../biweekly_schedule'
require_relative 'classification'

# Business Logic Which Changes the Employee Classification to Commissioned
module Comissioned
  ChangeClassification = ImmutableStruct.new(:id, :salary, :rate, :database) do
    include ::ChangeClassification

    def make_classification
      Classification.new(salary: salary, rate: rate)
    end

    def make_schedule
      BiweeklySchedule.new
    end
  end
end
