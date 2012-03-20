class UnionAffiliation
  attr_reader :dues, :memberId

  def initialize(memberId, dues)
    @service_charges = {}
    @dues = dues
    @memberId = memberId
  end

  def get_service_charge(date)
    @service_charges[date]
  end

  def add_service_charge(service_charge)
    @service_charges[service_charge.date] = service_charge
  end
end
