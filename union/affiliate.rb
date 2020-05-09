# frozen_string_literal: true

require_relative 'change_affiliation'
require_relative 'affiliation'

# Business Logic Which Changes the Employee Affiliation to UnionMember
module Union
  # TODO: investigate why dues is in plural
  Affiliate = ImmutableStruct.new(:id, :member_id, :dues, :database) do
    include ChangeAffiliation

    def make_affiliation
      Affiliation.new(member_id: member_id, dues: dues)
    end

    def record_membership(employee)
      database.add_union_member(member_id, employee)
    end
  end
end
