# frozen_string_literal: true
require 'rom-sql'

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
    def initialize(db_config = {})
      opts = {
          username: 'orbanbotond',
          password: '',
          encoding: 'UTF8',
          host: 'localhost',
          post: 5432,
          database: 'simple_payroll'
      }.merge(db_config)

      @config = ROM::Configuration.new(:sql, "postgres://#{opts[:host]}:#{opts[:port]}/#{opts[:database]}", opts)
      @config.register_relation(Relational::Relations::Employees)
      @config.register_relation(Relational::Relations::Schedules)
      @config.register_relation(Relational::Relations::UnionMembers)

      @rom_container = ROM.container(@config)
      @employee_repo = Relational::Repositories::Employee.new(container: @rom_container)
      @schedule_repo = Relational::Repositories::Schedule.new(container: @rom_container)
      @union_repo = Relational::Repositories::UnionMember.new(container: @rom_container)
    end

    def employee(id)
      e = @employee_repo.by_id_with_schedules(id)

      employee = Employee.new(e.id, e.name, e.address)
      schedule_map = {'Schedules::Weekly' => Schedules::Weekly, "Schedules::Monthly" => Schedules::Monthly, "Schedules::Biweekly" => Schedules::Biweekly}
      employee.schedule = schedule_map[e.schedule.type].new
      employee
    rescue ROM::TupleCountMismatchError
      nil
    end

    def add_employee(id, employee)
      @employee_repo.create_with_schedule(id: id, name: employee.name, address: employee.address, schedule: {type: employee.schedule.class.to_s})
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

class PayrollDatabase
  def self.instance
    @instance ||= Relational::PostgresqlDatabase.new
  end
end
