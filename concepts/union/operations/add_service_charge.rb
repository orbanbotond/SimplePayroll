# frozen_string_literal: true

# Business Logic Which Adds a ServiceCharge into the System
module Union
  module Operations
    AddServiceCharge = ImmutableStruct.new(:member_id, :date, :charge, :database) do
      def execute
        employee = database.union_member(member_id)
        union_affiliation = employee.affiliation
        service_charge = ServiceCharge.new(date, charge)
        union_affiliation.add_service_charge(service_charge)
        persisted_service_charge = database.add_service_charge(member_id, service_charge)
        # service_charge.id = persisted_service_charge.id
      end
    end
  end
end
