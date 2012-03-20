class ChangeEmployee
  def initialize(empId)
    @empId = empId
  end

  def execute
    e = PayrollDatabase.get_employee(@empId)

    if (e == nil)
      raise "Employee #{@empId} Not Found"
    else
      change(e)
    end
  end
end
