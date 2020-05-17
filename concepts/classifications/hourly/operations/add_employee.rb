# frozen_string_literal: true

# Business Logic Which Adds an Hourly Employee into the system
module Classifications
  module Hourly
    module Operations
      AddEmployee = ImmutableStruct.new(:id, :name, :address, :rate, :database) do
        include ::AddEmployee

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
