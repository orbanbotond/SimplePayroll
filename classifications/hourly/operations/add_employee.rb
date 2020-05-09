# frozen_string_literal: true

require File.join(Dir.getwd, 'application_boot')

require 'add_employee'
# TODO: the weekly schedule is s bit dubious why is it hardcoded here.
require 'weekly_schedule'
require_relative '../classification'

# Business Logic Which Adds an Hourly Employee into the system
module Hourly
  AddEmployee = ImmutableStruct.new(:id, :name, :address, :rate, :database) do
    include ::AddEmployee

    def make_classification
      Classification.new(rate: rate)
    end

    def make_schedule
      WeeklySchedule.new
    end
  end
end
