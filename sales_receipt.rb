# frozen_string_literal: true

# Models the SalesReceipt
class SalesReceipt
  attr_reader :date, :amount

  def initialize(date, amount)
    @date = date
    @amount = amount
  end
end
