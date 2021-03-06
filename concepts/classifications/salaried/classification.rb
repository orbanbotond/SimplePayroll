# frozen_string_literal: true

# Models the Classification
module Classifications
  module Salaried
    Classification = ImmutableStruct.new(:id, :salary) do
      attr_accessor :id

      def calculate_pay(_pay_check)
        salary
      end
    end
  end
end
