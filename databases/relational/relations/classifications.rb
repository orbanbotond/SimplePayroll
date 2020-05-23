module Relational
  module Relations
    class Classifications < ROM::Relation[:sql]
      schema(:classifications, infer: true) do
        associations do
          belongs_to :employee

          has_many :sales_receipts
          has_many :time_cards

          # Here we can construct the proper type
          # attribute :type, Types::String, read: Types.Constructor(Symbol, &:to_sym)
        end
      end
    end
  end
end


