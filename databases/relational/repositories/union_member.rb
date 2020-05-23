module Relational
  module Repositories
    class UnionMember < ROM::Repository[:union_memberships]
      commands :create, update: :by_pk, delete: :by_pk

      def by_id(id)
        union_members.by_pk(id).one!
      end

      def ids
        union_members.pluck(:id)
      end
    end
  end
end
