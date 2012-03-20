class MonthlySchedule
  def pay_date?(date)
    last_day_of_month?(date)
  end

  def last_day_of_month?(date)
    date.next_month.month == date.next_day.month
  end
end
