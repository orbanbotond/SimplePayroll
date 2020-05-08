# frozen_string_literal: true

require_relative 'union_affiliation'
require_relative 'change_affiliation'

# Business Logic Which Changes the Employee Affiliation to UnionMember
class ChangeUnionMember < ChangeAffiliation
  def initialize(emp_id, member_id, dues, database)
    super(emp_id, database)
    @dues = dues
    @member_id = member_id
  end

  def make_affiliation
    UnionAffiliation.new(@member_id, @dues)
  end

  def record_membership(employee)
    @database.add_union_member(@member_id, employee)
  end
end
