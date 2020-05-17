# frozen_string_literal: true

# Business Logic Which Adds a ServiceCharge into the System
module Union
  module Operations
    AddServiceCharge = ImmutableStruct.new(:member_id, :date, :charge, :database) do
      def execute
        employee = database.union_member(member_id)
        union_affiliation = employee.affiliation
        union_affiliation.add_service_charge(ServiceCharge.new(date, charge))
      end
    end
  end
end
