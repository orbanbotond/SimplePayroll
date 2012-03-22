class BiweeklySchedule
  def pay_date?(date)
    date.cweek.even? and date.friday?
  end

  def get_pay_period_start_date(pay_date)
    pay_date - 13
  end
end
