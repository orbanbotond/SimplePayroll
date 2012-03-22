require_relative "union_affiliation"
require_relative "change_affiliation"

class ChangeUnionMember < ChangeAffiliation
  def initialize(empId, memberId, dues, database)
    super(empId, database)
    @dues = dues
    @memberId = memberId
  end

  def make_affiliation
    UnionAffiliation.new(@memberId, @dues)
  end

  def record_membership(employee)
    @database.add_union_member(@memberId, employee)
  end
end
