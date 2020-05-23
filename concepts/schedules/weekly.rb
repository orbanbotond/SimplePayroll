# frozen_string_literal: true

# Models the Weekly
module Schedules
  class Weekly
    attr_accessor :id

    def pay_date?(date)
      date.friday?
    end

    def get_pay_period_start_date(pay_date)
      pay_date - 6
    end
  end
end
