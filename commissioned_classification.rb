# frozen_string_literal: true

# Models the CommissionedClassification of the employee
class CommissionedClassification
  attr_reader :salary, :rate

  def initialize(salary, rate)
    @salary = salary
    @rate = rate
    @receipts = []
  end

  def sales_receipts
    @receipts
  end

  def add_sales_receipt(sales_receipt)
    @receipts << sales_receipt
  end

  def calculate_pay(pay_check)
    range = ((pay_check.pay_date - 13)..(pay_check.pay_date))
    sales_for_period = @receipts.select do |sale|
      range.member? sale.date
    end

    commission = sales_for_period.inject(0) do |sum, sale|
      sum + sale.amount / @rate
    end
    @salary + commission
  end
end
