require_relative "time_card"

class AddTimeCard
  def initialize(date, hours, empId, database)
    @date = date
    @hours = hours
    @empId = empId
    @database = database
  end

  def execute
    e = @database.get_employee(@empId)

    if (e == nil)
      raise "No Employee Found"
    else
      hc = e.classification
      hc.add_time_card(TimeCard.new(@date, @hours))
    end
  end
end
