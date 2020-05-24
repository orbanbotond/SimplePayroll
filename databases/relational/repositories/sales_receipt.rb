# frozen_string_literal: true

module Relational
  module Repositories
    class SalesReceipt < ROM::Repository[:sales_receipts]
      commands :create, update: :by_pk, delete: :by_pk

      def by_id(id)
        sales_receipts.by_pk(id).one!
      end

      def by_classification_id(classification_id)
        where(classification_id: classification_id)
      end
    end
  end
end
