# frozen_string_literal: true

# Business Logic Which Changes the Employee Classification to Commissioned
module Classifications
  module Comissioned
    module Operations
      Change = ImmutableStruct.new(:id, :salary, :rate, :database) do
        include ::ChangeClassification

        def make_classification
          Classification.new(salary: salary, rate: rate)
        end

        def make_schedule
          Schedules::Biweekly.new
        end
      end
    end
  end
end
