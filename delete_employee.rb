class DeleteEmployee
  def initialize(empId)
    @empId = empId
  end

  def execute
    PayrollDatabase.delete_employee(@empId)
  end
end
