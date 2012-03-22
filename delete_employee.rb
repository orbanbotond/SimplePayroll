class DeleteEmployee
  def initialize(empId, database)
    @empId = empId
    @database = database
  end

  def execute
    @database.delete_employee(@empId)
  end
end
