# frozen_string_literal: true

# Models the CommissionedClassification of the employee
module Classifications
  module Comissioned
    Classification = ImmutableStruct.new(:salary, :rate) do
      def receipts
        @receipts ||= []
      end

      def sales_receipts
        receipts
      end

      def add_sales_receipt(sales_receipt)
        receipts << sales_receipt
      end

      def calculate_pay(pay_check)
        range = ((pay_check.start_date)..(pay_check.pay_date))
        sales_for_period = receipts.select do |sale|
          range.member? sale.date
        end

        commission = sales_for_period.inject(0) do |sum, sale|
          sum + sale.amount / rate
        end
        salary + commission
      end
    end
  end
end
