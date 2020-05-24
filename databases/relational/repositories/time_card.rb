module Relational
  module Repositories
    class TimeCard < ROM::Repository[:time_cards]
      commands :create, update: :by_pk, delete: :by_pk
    end
  end
end
