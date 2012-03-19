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
end
