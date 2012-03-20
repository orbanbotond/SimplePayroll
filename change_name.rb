require_relative "change_employee"

class ChangeName < ChangeEmployee
  def initialize(empId, name)
    super(empId)
    @name = name
  end

  def change(employee)
    employee.name = @name
  end
end
