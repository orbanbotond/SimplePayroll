# frozen_string_literal: true

require_relative '../change_employee'

module Union
  # Business Logic Which Changes the Affiliation of the Employee
  # expects to respond to these:
  # - record_membership
  # - make_affiliation
  module ChangeAffiliation
    include ::ChangeEmployee

    def change(employee)
      record_membership(employee)
      employee.affiliation = make_affiliation
    end
  end
end
