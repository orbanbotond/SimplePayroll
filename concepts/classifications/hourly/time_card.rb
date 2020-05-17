# frozen_string_literal: true

# Models the TimeCard
module Classifications
  module Hourly
    TimeCard = ImmutableStruct.new(:date, :hours)
  end
end
