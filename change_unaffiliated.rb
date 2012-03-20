class ChangeUnaffiliated < ChangeAffiliation
  def record_membership(employee)
    af = employee.affiliation
    memberId = af.memberId
    PayrollDatabase.remove_union_member(memberId)
  end

  def make_affiliation
    NoAffiliation.new
  end
end
