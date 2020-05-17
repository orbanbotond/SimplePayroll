module Relational
  module Relations
    class UnionMembers < ROM::Relation[:sql]
      schema(:union_members, infer: true) do
        associations do
          belongs_to :employee
        end
      end
    end
  end
end


