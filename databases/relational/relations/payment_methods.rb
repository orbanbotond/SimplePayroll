module Relational
  module Relations
    class PaymentMethods < ROM::Relation[:sql]
      schema(:payment_methods, infer: true) do
        associations do
          belongs_to :employee
        end
      end
    end
  end
end


