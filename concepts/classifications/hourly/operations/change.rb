# frozen_string_literal: true

# Business Logic Which Changes the Employee Classification to Hourly
module Classifications
  module Hourly
    module Operations
      Change = ImmutableStruct.new(:id, :rate, :database) do
        include ::ChangeClassification

        def make_classification
          Classification.new(rate: rate)
        end

        def make_schedule
          Schedules::Weekly.new
        end
      end
    end
  end
end
