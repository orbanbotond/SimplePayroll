# frozen_string_literal: true

# Models the WeeklySchedule
class WeeklySchedule
  def pay_date?(date)
    date.friday?
  end

  def get_pay_period_start_date(pay_date)
    pay_date - 6
  end
end
