# frozen_string_literal: true

# Business Logic Which Adds a SalariedEmployee into the system
module Classifications
  module Salaried
    module Operations
      AddEmployee = ImmutableStruct.new(:id, :name, :address, :salary, :database) do
        include ::AddEmployee

        def make_classification
          Classifications::Salaried::Classification.new(salary: salary)
        end

        def make_schedule
          Schedules::Monthly.new
        end
      end
    end
  end
end
