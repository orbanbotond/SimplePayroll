# frozen_string_literal: true

module Relational
  module Relations
    class ServiceCharges < ROM::Relation[:sql]
      schema(:service_charges, infer: true) do
        associations do
          belongs_to :union_membership
        end
      end
    end
  end
end
