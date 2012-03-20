class Paycheck
  attr_reader :pay_date
  attr_accessor :gross_pay, :deductions, :disposition

  def initialize(pay_date)
    @pay_date = pay_date
  end

  def net_pay
    gross_pay - deductions
  end
end
