# frozen_string_literal: true

# Models the MonthlySchedule of Payment
class MonthlySchedule
  def pay_date?(date)
    last_day_of_month?(date)
  end

  def last_day_of_month?(date)
    date.next_month.month == date.next_day.month
  end

  def get_pay_period_start_date(pay_date)
    Date.new(pay_date.year, pay_date.month, 1)
  end
end
