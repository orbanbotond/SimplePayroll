class CommissionedClassification
  attr_reader :salary, :rate

  def initialize(salary, rate)
    @salary = salary
    @rate = rate
    @receipts = []
  end

  def get_sales_receipts
    @receipts
  end

  def add_sales_receipt(sales_receipt)
    @receipts << sales_receipt
  end

  def calculate_pay(pc)
    range = ((pc.pay_date - 13)..(pc.pay_date))
    sales_for_period = @receipts.select do |sale|
      range.member? sale.date
    end

    commission = sales_for_period.inject(0) do |sum, sale|
      sum += sale.amount
    end
    @salary + @rate * commission
  end
end
