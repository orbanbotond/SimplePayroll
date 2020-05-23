module Relational
  module Relations
    class SalesReceipts < ROM::Relation[:sql]
      schema(:sales_receipts, infer: true) do
        # attribute :date, Types::Nominal::DateTime, read: Types::Coercible::Date

        associations do
          belongs_to :classification
        end
      end
    end
  end
end


