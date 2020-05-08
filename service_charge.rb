# frozen_string_literal: true

# Models the ServiceCharge
class ServiceCharge
  attr_reader :date, :charge

  def initialize(date, charge)
    @date = date
    @charge = charge
  end
end
