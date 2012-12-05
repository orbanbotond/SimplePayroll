require_relative "service_charge"

class AddServiceCharge
  def initialize(memberId, date, charge, database)
    @memberId = memberId
    @date = date
    @charge = charge
    @database = database
  end

  def execute
    e = @database.get_union_member(@memberId)
    ua = e.affiliation
    ua.add_service_charge(ServiceCharge.new(@date, @charge))
  end
end
