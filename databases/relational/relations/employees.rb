module Relational
  module Relations
    class Employees < ROM::Relation[:sql]
      schema(:employees, infer: true) do
        associations do
          has_one :schedule
          has_one :classification
          has_one :payment_method
          has_one :union_membership
        end
      end
      
      # attribute :id, Types::Int
      # attribute :name, Types::String
      # attribute :address, Types::String
    end
  end
end
