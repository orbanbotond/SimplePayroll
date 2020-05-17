module Relational
  module Repositories
    class Employee < ROM::Repository[:employees]
      commands :create, update: :by_pk, delete: :by_pk

      def create_with_all(employee)
        employees.combine(:schedule)
            .combine(:classification)
            .combine(:payment_methods)
            .command(:create)
            .call(employee)
      end

      def by_id(id)
        employees.by_pk(id).one!
      end

      def by_id_with_all(id)
        employees.by_pk(id)
            .combine(:schedule)
            .combine(:classification)
            .combine(:payment_method)
            .one!
      end

      def ids
        employees.pluck(:id)
      end
    end
  end
end