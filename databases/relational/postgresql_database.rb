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

    def initialize(db_config = {})
      @config = ROM::Configuration.new(:sql,self.class.connection_uri(self.class.connection_options), db_config)
      @config.register_relation(Relational::Relations::Employees)
      @config.register_relation(Relational::Relations::Schedules)
      @config.register_relation(Relational::Relations::UnionMembers)
      @config.register_relation(Relational::Relations::Classifications)
      @config.register_relation(Relational::Relations::PaymentMethods)

      @rom_container = ROM.container(@config)
      @employee_repo = Relational::Repositories::Employee.new(container: @rom_container)
      @schedule_repo = Relational::Repositories::Schedule.new(container: @rom_container)
      @union_repo = Relational::Repositories::UnionMember.new(container: @rom_container)
    end

    def employee(id)
      e = @employee_repo.by_id_with_all(id)

      employee = Employee.new(e.id, e.name, e.address)
      schedule_map = {'Schedules::Weekly' => Schedules::Weekly,
                      "Schedules::Monthly" => Schedules::Monthly,
                      "Schedules::Biweekly" => Schedules::Biweekly}
      employee.schedule = schedule_map[e.schedule.type].new

      classifications_map = {'Classifications::Comissioned::Classification' => Classifications::Comissioned::Classification,
                             "Classifications::Hourly::Classification" => Classifications::Hourly::Classification,
                             "Classifications::Salaried::Classification" => Classifications::Salaried::Classification}
      employee.classification =  classifications_map[e.classification.type].new(e.classification.to_h)

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

    def add_union_member(id, employee)
      @union_repo.create(id: id, employee_id: employee.id)
    end

    def union_member(id)
      @union_repo.by_id(id)
    end

    def remove_union_member(id)
      @members.delete(id)
    end

    def all_employee_ids
      @employee_repo.ids
    end
  end
end
