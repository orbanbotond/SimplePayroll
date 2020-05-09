# frozen_string_literal: true

# Models the No Affiliation
class NoAffiliation
  def member_id
    nil
  end

  def dues
    0
  end

  def calculate_deductions(_paycheck)
    0
  end
end
