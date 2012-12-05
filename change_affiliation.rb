require_relative "change_employee"

class ChangeAffiliation < ChangeEmployee
  def initialize(empId, database)
    super(empId, database)
  end

  def change(e)
    record_membership(e)
    e.affiliation = make_affiliation
  end
end
