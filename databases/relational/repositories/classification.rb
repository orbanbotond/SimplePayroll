# frozen_string_literal: true

module Relational
  module Repositories
    class Classification < ROM::Repository[:classifications]
      commands update: :by_pk

      def by_id(id)
        classifications.by_pk(id).one!
      end
    end
  end
end
