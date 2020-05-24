require 'rom/transformer'

module Relational
  module Mappers
    class ComplexEmployee < ROM::Transformer
      relation :employees, as: :employee_with_everything_mapper

      def initialize
        @transproc = transformer_proc
      end

      def transformer_proc
        -> employees do
          employees.map do |employee_data|
            employee = Employee.new(id: employee_data.id, name: employee_data.name, address: employee_data.address)
            schedule_map = {'Schedules::Weekly' => Schedules::Weekly,
                            "Schedules::Monthly" => Schedules::Monthly,
                            "Schedules::Biweekly" => Schedules::Biweekly}
            employee.schedule = schedule_map[employee_data.schedule.type].new
            employee.schedule.id = employee_data.schedule.id

            classifications_map = {'Classifications::Comissioned::Classification' => Classifications::Comissioned::Classification,
                                   "Classifications::Hourly::Classification" => Classifications::Hourly::Classification,
                                   "Classifications::Salaried::Classification" => Classifications::Salaried::Classification}
            employee.classification =  classifications_map[employee_data.classification.type].new(employee_data.classification.to_h)
            employee_data.classification.sales_receipts.each do |receipt|
              employee.classification.add_sales_receipt(receipt)
            end
            employee_data.classification.time_cards.each do |time_cards|
              employee.classification.add_time_card(time_cards)
            end

            if(employee_data.union_membership.present?)
              employee.affiliation = Union::Affiliation.new(member_id: employee_data.union_membership.id, dues: employee_data.union_membership.dues)
              employee_data.union_membership.service_charges.each do |service_charge|
                employee.affiliation.add_service_charge(Union::ServiceCharge.new(service_charge.date, service_charge.charge))
              end
            else
              employee.affiliation = Union::NoAffiliation.new
            end

            payment_methods_map = {'PaymentMethods::Hold' => PaymentMethods::Hold}
            employee.payment_method =  payment_methods_map[employee_data.payment_method.type].new()
            employee
          end
        end
      end
    end
  end
end
