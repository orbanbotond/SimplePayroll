class HourlyClassification
  attr_reader :rate

  def initialize(rate)
    @rate = rate
    @timecards = {}
  end

  def get_time_card(date)
    @timecards[date]
  end

  def add_time_card(time_card)
    @timecards[time_card.date] = time_card
  end

  def calculate_pay(pc)
    date_range = ((pc.pay_date - 6)..(pc.pay_date))
    time_cards_for_period = @timecards.select do |date, time_card|
      date_range.member? date
    end.values

    hours_for_period = time_cards_for_period.inject(0) do |sum, time_card|
      overtime_hours = [time_card.hours - 8, 0].max
      normal_hours = time_card.hours - overtime_hours
      sum += normal_hours + overtime_hours * 1.5
    end

    hours_for_period * rate
  end
end
