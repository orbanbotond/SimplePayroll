# frozen_string_literal: true

# Models the SalariedClassification
class SalariedClassification
  attr_accessor :salary

  def initialize(salary)
    @salary = salary
  end

  def calculate_pay(_pay_check)
    @salary
  end
end
