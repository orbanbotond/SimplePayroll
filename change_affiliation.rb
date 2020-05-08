# frozen_string_literal: true

require_relative 'change_employee'

# Business Logic Which Changes the Affiliation of the Employee
class ChangeAffiliation < ChangeEmployee
  def initialize(emp_id, database)
    super(emp_id, database)
  end

  def change(employee)
    record_membership(employee)
    employee.affiliation = make_affiliation
  end
end
