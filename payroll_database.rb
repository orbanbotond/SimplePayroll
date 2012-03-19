class PayrollDatabase

  def self.employees
    @hash ||= {}
  end

  def self.get_employee(id)
    employees[id]
  end

  def self.add_employee(id, employee)
    employees[id] = employee
  end
end
