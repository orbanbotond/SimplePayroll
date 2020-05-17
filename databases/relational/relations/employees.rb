module Relational
  module Relations
    class Employees < ROM::Relation[:sql]
      schema(:employees, infer: true) do
        associations do
          has_one :schedule
        end
      end
      # attribute :id, Types::Int
      # attribute :name, Types::String
      # attribute :address, Types::String
    end
  end
end
