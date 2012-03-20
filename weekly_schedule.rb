class WeeklySchedule
  def pay_date?(date)
    date.friday?
  end
end
