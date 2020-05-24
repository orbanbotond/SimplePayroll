# frozen_string_literal: true

module Relational
  module Relations
    class TimeCards < ROM::Relation[:sql]
      schema(:time_cards, infer: true) do
        associations do
          belongs_to :classification
        end
      end
    end
  end
end
