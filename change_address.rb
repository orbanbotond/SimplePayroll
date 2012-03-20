require_relative "change_employee"

class ChangeAddress < ChangeEmployee
  def initialize(empId, address)
    super(empId)
    @address = address
  end

  def change(employee)
    employee.address = @address
  end
end
