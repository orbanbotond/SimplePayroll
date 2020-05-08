# frozen_string_literal: true

# Business Logic Which Removes the Employee Affiliation
class ChangeUnaffiliated < ChangeAffiliation
  def record_membership(employee)
    affiliation = employee.affiliation
    @database.remove_union_member(affiliation.member_id)
  end

  def make_affiliation
    NoAffiliation.new
  end
end
