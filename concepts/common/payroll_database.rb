# frozen_string_literal: true

# Models a simple in memory Database
class PayrollDatabase
  def self.instance
    @instance ||= PayrollDatabase.new
  end

  def employee(id)
    @employees[id]
  end

  def add_employee(id, employee)
    @employees[id] = employee
  end

  def update_employee(employee)
    employee
  end

  def delete_employee(id)
    @employees.delete(id)
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
    @employees.keys
  end

  private

  def initialize
    @employees = {}
    @members = {}
  end
end
