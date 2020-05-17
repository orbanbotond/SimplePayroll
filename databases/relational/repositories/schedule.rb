module Relational
  module Repositories
    class Schedule < ROM::Repository[:schedules]
      commands :create, update: :by_pk, delete: :by_pk

      def by_id(id)
        schedules.by_pk(id).one!
      end
    end
  end
end
