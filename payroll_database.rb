class PayrollDatabase

  def self.instance
    @db ||= PayrollDatabase.new
  end

  def initialize
    @employees = {}
    @members = {}
  end

  def get_employee(id)
    @employees[id]
  end

  def add_employee(id, employee)
    @employees[id] = employee
  end

  def delete_employee(id)
    @employees.delete(id)
  end

  def add_union_member(id, employee)
    @members[id] = employee
  end

  def get_union_member(id)
    @members[id]
  end

  def remove_union_member(id)
    @members.delete(id)
  end

  def get_all_employee_ids
    @employees.keys
  end


  def self.employees
    @employees ||= {}
  end

  def self.members
    @members ||= {}
  end

  def self.get_employee(id)
    employees[id]
  end

  def self.add_employee(id, employee)
    employees[id] = employee
  end

  def self.delete_employee(id)
    employees.delete(id)
  end

  def self.add_union_member(id, employee)
    members[id] = employee
  end

  def self.get_union_member(id)
    members[id]
  end

  def self.remove_union_member(id)
    members.delete(id)
  end

  def self.get_all_employee_ids
    employees.keys
  end
end
