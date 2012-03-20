require_relative "service_charge"

class AddServiceCharge
  def initialize(memberId, date, charge)
    @memberId = memberId
    @date = date
    @charge = charge
  end

  def execute
    e = PayrollDatabase.get_union_member(@memberId)

    if (e == nil)
      raise "Member #{@memberId} Not Found"
    else
      ua = e.affiliation
      ua.add_service_charge(ServiceCharge.new(@date, @charge))
    end
  end
end
