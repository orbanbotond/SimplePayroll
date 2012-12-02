class ChangeUnaffiliated < ChangeAffiliation
  def record_membership(employee)
    af = employee.affiliation
    @database.remove_union_member(af.memberId)
  end

  def make_affiliation
    NoAffiliation.new
  end
end
