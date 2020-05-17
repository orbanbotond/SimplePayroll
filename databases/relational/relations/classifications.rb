module Relational
  module Relations
    class Classifications < ROM::Relation[:sql]
      schema(:classifications, infer: true) do
        associations do
          belongs_to :employee
        end
      end
    end
  end
end


