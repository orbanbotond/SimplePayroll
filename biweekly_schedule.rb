# frozen_string_literal: true

# Models the BiweeklySchedule
class BiweeklySchedule
  def pay_date?(date)
    date.cweek.even? && date.friday?
  end

  def get_pay_period_start_date(pay_date)
    pay_date - 13
  end
end
