# frozen_string_literal: true

require_relative '../change_classification'
require_relative '../weekly_schedule'
require_relative 'classification'

# Business Logic Which Changes the Employee Classification to Hourly
module Hourly
  ChangeClassification = ImmutableStruct.new(:id, :rate, :database) do
    include ::ChangeClassification

    def make_classification
      Classification.new(rate: rate)
    end

    def make_schedule
      WeeklySchedule.new
    end
  end
end
