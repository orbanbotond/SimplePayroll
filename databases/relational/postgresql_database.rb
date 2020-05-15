# frozen_string_literal: true
require 'rom-sql'

# config->container
# relation -> schema/commands
# repository -> commands/query methods

opts = {
    username: 'orbanbotond',
    password: '',
    encoding: 'UTF8',
    host: 'localhost',
    post: 5432,
    database: 'simple_payroll'
}

postgresql_config = ROM::Configuration.new(:sql, "postgres://#{opts[:host]}:#{opts[:port]}/#{opts[:database]}", opts)

# postgresql_config.default.create_table(:employees) do
#   primary_key :id
#   # classification, :schedule, :payment_method, :affiliation, :name, :address
#   column :name, String, null: false
#   column :address, String, null: false
# end

class Employees < ROM::Relation[:sql]
  schema(infer: true)
  # attribute :id, Types::Int
  # attribute :name, Types::String
  # attribute :address, Types::String
end
postgresql_config.register_relation(Employees)

class EmployeeRepo < ROM::Repository[:employees]
  commands :create, update: :by_pk, delete: :by_pk

  def by_id(id)
    employees.by_pk(id).one!
  end

  def ids
    employees.pluck(:id)
  end
end

# Models a simple in memory Database
class PostgresqlDatabase
  def initialize(config)
    @config = config
    @rom_container = ROM.container(config)
    @employee_repo = EmployeeRepo.new(container: @rom_container)
  end

  def employee(id)
    @employee_repo.by_id(id)
  rescue ROM::TupleCountMismatchError
    nil
  end

  def add_employee(id, employee)
    @employee_repo.create(id: id, name: employee.name, address: employee.address)
  end

  def delete_employee(id)
    @employee_repo.delete(id)
  end

  def add_union_member(id, employee)
    @members[id] = employee
  end

  def union_member(id)
    @members[id]
  end

  def remove_union_member(id)
    @members.delete(id)
  end

  def all_employee_ids
    @employee_repo.ids
  end
end

class PayrollDatabase
  def self.instance
    @instance ||= PostgresqlDatabase.new(@config)
  end

  def self.config(postgresql_config)
    @config = postgresql_config
  end
end

PayrollDatabase.config(postgresql_config)
