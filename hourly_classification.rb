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
end
