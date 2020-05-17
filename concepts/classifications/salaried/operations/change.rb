# frozen_string_literal: true

# Business Logic Which Changes the Employee Classification to Salaried
module Classifications
  module Salaried
    module Operations
      Change = ImmutableStruct.new(:id, :salary, :database) do
        include ::ChangeClassification

        def make_classification
          Salaried::Classification.new(salary: salary)
        end

        def make_schedule
          Schedules::Monthly.new
        end
      end
    end
  end
end
