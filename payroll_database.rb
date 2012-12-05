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
end
