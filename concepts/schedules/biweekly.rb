# frozen_string_literal: true

# Models the Biweekly
module Schedules
  class Biweekly
    attr_accessor :id

    def pay_date?(date)
      date.cweek.even? && date.friday?
    end

    def get_pay_period_start_date(pay_date)
      pay_date - 13
    end
  end
end
