# frozen_string_literal: true

require File.join(Dir.getwd, 'application_boot')

require 'add_employee'
# TODO: the biweekly schedule is s bit dubious why is it hardcoded here.
require 'biweekly_schedule'
require_relative '../classification'

# Business Logic Which Adds a Commissioned Employee
module Comissioned
  AddEmployee = ImmutableStruct.new(:id, :name, :address, :salary, :rate, :database) do
    include ::AddEmployee

    def make_classification
      Classification.new(salary: salary, rate: rate)
    end

    # @todo why biweekly? should that aspect be independent of the commissions?
    # this seems like a hard wired rule
    def make_schedule
      BiweeklySchedule.new
    end
  end
end
