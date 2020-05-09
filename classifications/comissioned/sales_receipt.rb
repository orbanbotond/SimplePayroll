# frozen_string_literal: true

# Models the SalesReceipt
module Comissioned
  SalesReceipt = ImmutableStruct.new(:date, :amount)
end
