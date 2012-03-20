class PayrollDatabase

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
end
