require_relative "paycheck"

class Payday
  def initialize(pay_date, database)
    @pay_date = pay_date
    @database = database
    @paychecks = {}
  end

  def execute
    empIds = @database.get_all_employee_ids
    empIds.each do |empId|
      employee = @database.get_employee(empId)
      if (employee.pay_date?(@pay_date))
        start_date = employee.get_pay_period_start_date(@pay_date)
        pc = Paycheck.new(start_date, @pay_date)
        @paychecks[empId] = pc
        employee.payday(pc)
      end
    end
  end

  def get_paycheck(empId)
    @paychecks[empId]
  end
end
