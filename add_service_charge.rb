# frozen_string_literal: true

require_relative 'service_charge'

# Business Logic Which Adds a ServiceCharge into the System
class AddServiceCharge
  def initialize(member_id, date, charge, database)
    @member_id = member_id
    @date = date
    @charge = charge
    @database = database
  end

  def execute
    e = @database.union_member(@member_id)
    ua = e.affiliation
    ua.add_service_charge(ServiceCharge.new(@date, @charge))
  end
end
