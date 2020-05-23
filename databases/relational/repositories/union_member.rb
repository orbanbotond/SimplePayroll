module Relational
  module Repositories
    class UnionMember < ROM::Repository[:union_memberships]
      commands :create, update: :by_pk, delete: :by_pk

      def by_id(id)
        union_memberships.by_pk(id).one!
      end

      def ids
        union_memberships.pluck(:id)
      end
    end
  end
end
