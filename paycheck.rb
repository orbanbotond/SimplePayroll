class Paycheck
  attr_reader :pay_date, :start_date
  attr_accessor :gross_pay, :deductions, :disposition

  def initialize(start_date, pay_date)
    @start_date = start_date
    @pay_date = pay_date
  end

  def net_pay
    gross_pay - deductions
  end
end
