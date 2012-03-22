require_relative "change_employee"

class ChangeName < ChangeEmployee
  def initialize(empId, name, database)
    super(empId, database)
    @name = name
  end

  def change(employee)
    employee.name = @name
  end
end
