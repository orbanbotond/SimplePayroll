module Relational
  module Relations
    class Schedules < ROM::Relation[:sql]
      schema(:schedules, infer: true) do
        associations do
          belongs_to :employee
        end
      end
    end
  end
end
