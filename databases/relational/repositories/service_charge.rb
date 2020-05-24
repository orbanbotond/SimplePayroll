module Relational
  module Repositories
    class ServiceCharge < ROM::Repository[:service_charges]
      commands :create, update: :by_pk, delete: :by_pk
    end
  end
end
