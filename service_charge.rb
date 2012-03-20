class ServiceCharge
  attr_reader :date, :charge

  def initialize(date, charge)
    @date = date
    @charge = charge
  end
end
