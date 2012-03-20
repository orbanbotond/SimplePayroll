require_relative "change_employee"

class ChangeAffiliation < ChangeEmployee
  def initialize(empId)
    super(empId)
  end

  def change(employee)
    record_membership(employee)
    af = make_affiliation
    employee.affiliation = af
  end
end
