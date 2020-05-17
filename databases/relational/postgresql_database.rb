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
#   # classification, :payment_method, :affiliation, :name, :address
#   column :name, String, null: false
#   column :address, String, null: false
# end
# postgresql_config.default.create_table(:schedules) do
#   primary_key :id
#   column :type, String, null: false
#   column :employee_id, String, null: false
# end

class Employees < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      has_one :schedule
    end
  end
  # attribute :id, Types::Int
  # attribute :name, Types::String
  # attribute :address, Types::String
end
postgresql_config.register_relation(Employees)

class Schedules < ROM::Relation[:sql]
  schema(infer: true) do
    associations do
      belongs_to :employee
    end
  end
end
postgresql_config.register_relation(Schedules)

class EmployeeRepo < ROM::Repository[:employees]
  commands :create, update: :by_pk, delete: :by_pk

  def by_id(id)
    employees.by_pk(id).one!
  end

  def by_id_with_schedules(id)
    employees.by_pk(id).combine(:schedule).one!
  end

  def ids
    employees.pluck(:id)
  end
end
class ScheduleRepo < ROM::Repository[:schedules]
  commands :create, update: :by_pk, delete: :by_pk

  def by_id(id)
    schedules.by_pk(id).one!
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
    @schedule_repo = ScheduleRepo.new(container: @rom_container)
  end

  def employee(id)
    e = @employee_repo.by_id_with_schedules(id)

    employee = Employee.new(e.id, e.name, e.address)
    employee.schedule = Weekly.new if e.schedule.type == "Weekly"
    employee.schedule = Monthly.new if e.schedule.type == "Monthly"
    employee.schedule = Biweekly.new if e.schedule.type == "Biweekly"
  rescue ROM::TupleCountMismatchError
    nil
  end

  def add_employee(id, employee)
    @employee_repo.create(id: id, name: employee.name, address: employee.address)
    @schedule_repo.create(type: employee.schedule.class.to_s, employee_id: employee.id)
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
