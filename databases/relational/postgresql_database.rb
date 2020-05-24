# frozen_string_literal: true
require 'rom-sql'
require 'yaml'

# config->container
# relation -> schema/commands
# repository -> commands/query methods

# postgresql_config.default.create_table(:employees) do
#   primary_key :id
#   # classification, :payment_method, :affiliation, :name, :address
#   column :name, String, null: false
#   column :address, String, null: false
# end
# postgresql_config.default.create_table(:schedules) do
#   primary_key :id
#   column :type, String, null: false
#   column :employee_id, String, null: false
# end

# Models a simple in memory Database
module Relational
  class PostgresqlDatabase

    class << self
      def connection_options
        db_config_file_location =  File.join APP_ROOT, 'databases', 'relational', 'database.yml'
        db_config = YAML.load File.read(db_config_file_location)
        db_config[$payroll_environment.to_s]
      end

      def connection_uri(options)
        "postgres://#{options['username']}:#{options['password']}@#{options['host']}:#{options['port']}/#{options['database']}"
      end
    end

    attr_reader :schedule_repo, :classification_repo

    def initialize(db_config = {})
      @config = ROM::Configuration.new(:sql,self.class.connection_uri(self.class.connection_options), db_config)
      @config.register_relation(Relational::Relations::Employees)
      @config.register_relation(Relational::Relations::Schedules)
      @config.register_relation(Relational::Relations::UnionMembers)
      @config.register_relation(Relational::Relations::Classifications)
      @config.register_relation(Relational::Relations::PaymentMethods)
      @config.register_relation(Relational::Relations::SalesReceipts)
      @config.register_relation(Relational::Relations::TimeCards)
      @config.register_relation(Relational::Relations::ServiceCharges)
      @config.register_mapper(Relational::Mappers::UnionMember)

      @rom_container = ROM.container(@config)
      @employee_repo = Relational::Repositories::Employee.new(container: @rom_container)
      @schedule_repo = Relational::Repositories::Schedule.new(container: @rom_container)
      @union_repo = Relational::Repositories::UnionMember.new(container: @rom_container)
      @receipts_repo = Relational::Repositories::SalesReceipt.new(container: @rom_container)
      @classification_repo = Relational::Repositories::Classification.new(container: @rom_container)
      @service_charge_repo = Relational::Repositories::ServiceCharge.new(container: @rom_container)
      @time_card_repo = Relational::Repositories::TimeCard.new(container: @rom_container)
    end

    def add_service_charge(union_member_id, service_charge)
      @service_charge_repo.create(union_membership_id: union_member_id, date: service_charge.date, charge: service_charge.charge)
    end

    def add_time_card(hourly_classification, time_card)
      @time_card_repo.create(classification_id: hourly_classification.id, date: time_card.date, hours: time_card.hours)
    end

    def employee(id)
      e = @employee_repo.by_id_with_all(id)
      employee = Employee.new(id: e.id, name: e.name, address: e.address)
      schedule_map = {'Schedules::Weekly' => Schedules::Weekly,
                      "Schedules::Monthly" => Schedules::Monthly,
                      "Schedules::Biweekly" => Schedules::Biweekly}
      employee.schedule = schedule_map[e.schedule.type].new
      employee.schedule.id = e.schedule.id

      # TODO try to put this into the schema mapper!
      classifications_map = {'Classifications::Comissioned::Classification' => Classifications::Comissioned::Classification,
                             "Classifications::Hourly::Classification" => Classifications::Hourly::Classification,
                             "Classifications::Salaried::Classification" => Classifications::Salaried::Classification}
      employee.classification =  classifications_map[e.classification.type].new(e.classification.to_h)
      e.classification.sales_receipts.each do |receipt|
        employee.classification.add_sales_receipt(receipt)
      end
      e.classification.time_cards.each do |time_cards|
        employee.classification.add_time_card(time_cards)
      end

      if(e.union_membership.present?)
        employee.affiliation = Union::Affiliation.new(member_id: e.union_membership.id, dues: e.union_membership.dues)
        e.union_membership.service_charges.each do |service_charge|
          employee.affiliation.add_service_charge(Union::ServiceCharge.new(service_charge.date, service_charge.charge))
        end
      else
        employee.affiliation = Union::NoAffiliation.new
      end

      payment_methods_map = {'PaymentMethods::Hold' => PaymentMethods::Hold}
      employee.payment_method =  payment_methods_map[e.payment_method.type].new()
      employee
    rescue ROM::TupleCountMismatchError
      nil
    end

    def add_employee(id, employee)
      classification = employee.classification
      @employee_repo.create_with_all(id: id, name: employee.name, address: employee.address,
                                            schedule: {type: employee.schedule.class.to_s},
                                            classification: {type: classification.class.to_s,
                                                             salary: classification.try(:salary),
                                                             rate: classification.try(:rate)},
                                            payment_method: {type: employee.payment_method.class.to_s}
                                      )
    end

    def update_employee(employee)
      @employee_repo.update(employee.id, name: employee.name, address: employee.address)
    end

    def delete_employee(id)
      @employee_repo.delete(id)
    end

    def add_union_member(id, employee, dues)
      @union_repo.create(id: id, employee_id: employee.id, dues: dues)
    end

    def union_member(id)
      @employee_repo.by_union_membership_id(id).map_with(:employee_with_union_mapper).first
    end

    def remove_union_member(id)
      @union_repo.delete(id)
    end

    def all_employee_ids
      @employee_repo.ids
    end

    # def sales_receipts(classification)
    #   @receipts_repo.by_classification_id(classification.id)
    # end

    def add_receipt(classification, receipt)
      @receipts_repo.create(classification_id: classification.id, date: receipt.date, amount: receipt.amount)
    end
  end
end
