# frozen_string_literal: true

require_relative '../change_affiliation'

# Business Logic Which Removes the Employee Affiliation
module Union
  UnAffiliate = ImmutableStruct.new(:id, :database) do
    include ChangeAffiliation

    def record_membership(employee)
      affiliation = employee.affiliation
      database.remove_union_member(affiliation.member_id)
    end

    def make_affiliation
      NoAffiliation.new
    end
  end
end
