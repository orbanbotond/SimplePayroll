class TimeCard
  attr_reader :date, :hours

  def initialize(date, hours)
    @date = date
    @hours = hours
  end
end
