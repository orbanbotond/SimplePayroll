# frozen_string_literal: true

require_relative 'change_employee'

# A generic Business Logic module Which Changes the Employee Classification
# expects to respond to these:
# - database
# - id
# - make_classification
# - make_schedule
module ChangeClassification
  include ChangeEmployee

  def change(employee)
    employee.classification = make_classification
    employee.schedule = make_schedule
  end
end
