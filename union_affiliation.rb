class UnionAffiliation
  attr_accessor :dues

  def initialize
    @service_charges = {}
  end

  def get_service_charge(date)
    @service_charges[date]
  end

  def add_service_charge(service_charge)
    @service_charges[service_charge.date] = service_charge
  end
end
