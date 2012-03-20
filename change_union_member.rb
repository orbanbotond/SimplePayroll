require_relative "union_affiliation"
require_relative "change_affiliation"

class ChangeUnionMember < ChangeAffiliation
  def initialize(empId, memberId, dues)
    super(empId)
    @dues = dues
    @memberId = memberId
  end

  def make_affiliation
    uf = UnionAffiliation.new
    uf.dues = @dues
    uf
  end

  def record_membership(employee)
    PayrollDatabase.add_union_member(@memberId, employee)
  end
end
