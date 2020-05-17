# frozen_string_literal: true

# Business Logic Which Adds a Commissioned Employee
module Classifications
  module Comissioned
    module Operations
      AddEmployee = ImmutableStruct.new(:id, :name, :address, :salary, :rate, :database) do
        include ::AddEmployee

        def make_classification
          Classification.new(salary: salary, rate: rate)
        end

        # @todo why biweekly? should that aspect be independent of the commissions?
        # this seems like a hard wired rule
        def make_schedule
          Schedules::Biweekly.new
        end
      end
    end
  end
end
