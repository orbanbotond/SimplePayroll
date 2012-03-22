require_relative "change_employee"

class ChangeAddress < ChangeEmployee
  def initialize(empId, address, database)
    super(empId, database)
    @address = address
  end

  def change(employee)
    employee.address = @address
  end
end
