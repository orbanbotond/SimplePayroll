# frozen_string_literal: true

# A generic Business Logic module Which Changes the Employee Classification
# expects to respond to these:
# - database
# - id
# - make_classification
# - make_schedule
module ChangeClassification
  # We don't need the code from Change employee... bad include
  include ChangeEmployee

  def change(employee)
    old_classification_id = employee.classification.id
    old_schedule_id = employee.schedule.id
    employee.classification = make_classification
    employee.schedule = make_schedule

    # Future version
    # mark the old classifications and the old schedules inactive
    # add a new entry
    database.update_classification(old_classification_id,
                                   type: employee.classification.class.to_s,
                                   salary: employee.classification.try(:salary),
                                   rate: employee.classification.try(:rate))

    database.update_schedule(old_schedule_id,
                             type: employee.schedule.class.to_s)
  end
end
