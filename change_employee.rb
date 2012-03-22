class ChangeEmployee
  def initialize(empId, database)
    @empId = empId
    @database = database
  end

  def execute
    e = @database.get_employee(@empId)

    if (e == nil)
      raise "Employee #{@empId} Not Found"
    else
      change(e)
    end
  end
end
