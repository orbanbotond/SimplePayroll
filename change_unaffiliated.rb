class ChangeUnaffiliated < ChangeAffiliation
  def record_membership(e)
    af = e.affiliation
    @database.remove_union_member(af.memberId)
  end

  def make_affiliation
    NoAffiliation.new
  end
end
