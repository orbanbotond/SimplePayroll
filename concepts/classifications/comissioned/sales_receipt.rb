# frozen_string_literal: true

# Models the SalesReceipt
module Classifications
  module Comissioned
    SalesReceipt = ImmutableStruct.new(:date, :amount)
  end
end
