# frozen_string_literal: true

module Relational
  module Relations
    class UnionMembers < ROM::Relation[:sql]
      schema(:union_memberships, infer: true) do
        associations do
          belongs_to :employee
          has_many :service_charges
        end
      end
    end
  end
end
