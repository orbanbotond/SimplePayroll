module Relational
  module Repositories
    class Employee < ROM::Repository[:employees]
      commands :create, update: :by_pk, delete: :by_pk

      def create_with_all(employee)
        employees.combine(:schedule)
            .combine(:classification)
            .combine(:payment_method)
            .command(:create)
            .call(employee)
      end

      def by_id(id)
        employees.by_pk(id).one!
      end

      def by_union_membership_id(id)
        # e = employees.join(:union_memberships)
        #         .where{|union_memberships:|union_memberships[:id].is(id)}.one
        e = employees.wrap(:union_memberships)
                .where{|union_memberships:|union_memberships[:id].is(id)}
      end

      def by_id_with_all(id)
        employees.by_pk(id)
            .combine(:schedule)
            .combine(classification: [:sales_receipts, :time_cards])
            .combine(:payment_method)
            .combine(union_membership: :service_charges)
            .one!
      end

      def ids
        employees.pluck(:id)
      end
    end
  end
end
