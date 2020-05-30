# frozen_string_literal: true

require 'rom/transformer'

require 'transproc/all'

module Transproc
  module ClassTransformations
    def self.empty_constructor_inject(*args, klass)
      klass.new
    end
    def self.affiliation_constructor_inject(args)
      instance = Union::Affiliation.new(args.slice(:member_id, :dues))
      args[:service_charges].each do |charge|
        instance.add_service_charge(charge)
      end
      instance
    end
    def self.schedule_constructor_inject(args)
      schedule_map = { 'Schedules::Weekly' => Schedules::Weekly,
                       'Schedules::Monthly' => Schedules::Monthly,
                       'Schedules::Biweekly' => Schedules::Biweekly }
      schedule = schedule_map[args[:type]].new
      schedule.id = args[:id]
      schedule
    end
    def self.payment_method_constructor_inject(args)
      payment_methods_map = { 'PaymentMethods::Hold' => PaymentMethods::Hold }
      payment_methods_map[args[:type]].new
    end
    def self.classification_constructor_inject(args)
      classifications_map = { 'Classifications::Comissioned::Classification' => Classifications::Comissioned::Classification,
                              'Classifications::Hourly::Classification' => Classifications::Hourly::Classification,
                              'Classifications::Salaried::Classification' => Classifications::Salaried::Classification }
      classification = classifications_map[args[:type]].new(args.reject{|k,v| [:type, :sales_receipts, :time_cards].include? k })
      args[:sales_receipts].each do |receipt|
        classification.add_sales_receipt(receipt)
      end
      args[:time_cards].each do |time_card|
        classification.add_time_card(time_card)
      end
      classification
    end
    def self.employee_constructor_inject(args)
      employee = Employee.new(args.slice(:id, :name, :address, :affiliation))
      employee.classification = args[:classification]
      employee.schedule = args[:schedule]
      employee.payment_method = args[:payment_method]
      employee
    end
    def self.service_charge_constructor_inject(args)
      Union::ServiceCharge.new(args[:date], args[:charge])
    end
  end
end

module Relational
  module Mappers
    class ComplexEmployee < ROM::Transformer
      relation :employees, as: :employee_with_everything_mapper

      import Transproc::ArrayTransformations
      import Transproc::HashTransformations
      import Transproc::ClassTransformations
      import Transproc::Conditional
      import Transproc::Coercions

      map_array do
        # deep_symbolize_keys

        rename_keys union_membership: :affiliation
        map_value :affiliation do
          is Hash do
            rename_keys id: :member_id
            map_value :service_charges do
              map_array do
                accept_keys [:date, :charge]
                service_charge_constructor_inject
              end
            end
            affiliation_constructor_inject
          end
          is NilClass do
            empty_constructor_inject Union::NoAffiliation
          end
        end
        map_value :schedule do
          schedule_constructor_inject
        end
        map_value :payment_method do
          payment_method_constructor_inject
        end
        map_value :classification do
          map_value :sales_receipts do
            map_array do
              accept_keys [:date, :amount]
              constructor_inject Classifications::Comissioned::SalesReceipt
            end
          end
          map_value :time_cards do
            map_array do
              accept_keys [:date, :hours]
              constructor_inject Classifications::Hourly::TimeCard
            end
          end
          accept_keys [:id, :type, :salary, :rate, :sales_receipts, :time_cards]
          classification_constructor_inject
        end

        employee_constructor_inject
      end
    end
  end
end
