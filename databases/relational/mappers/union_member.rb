require 'rom/transformer'

module Relational
  module Mappers
    class UnionMember < ROM::Transformer
      relation :employees, as: :employee_with_union_mapper

      map_array do |e|
        symbolize_keys
        rename_keys union_membership: :affiliation
        map_value :affiliation do
          rename_keys id: :member_id
          constructor_inject Union::Affiliation
        end
        constructor_inject Employee
      end
    end
  end
end
