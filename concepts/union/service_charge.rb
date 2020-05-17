# frozen_string_literal: true

# Models the ServiceCharge
module Union
  class ServiceCharge
    attr_reader :date, :charge

    def initialize(date, charge)
      @date = date
      @charge = charge
    end
  end
end
