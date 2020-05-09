# frozen_string_literal: true

require_relative 'time_card'

# Business Logic Which Adds a Time Card Into The System
module Hourly
  AddTimeCard = ImmutableStruct.new(:date, :hours, :id, :database) do
    def execute
      employee = database.employee(id)
      raise 'No Employee Found' unless employee.present?

      hourly_classification = employee.classification
      hourly_classification.add_time_card(TimeCard.new(date: date, hours: hours))
    end
  end
end
