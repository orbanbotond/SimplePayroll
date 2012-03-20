require_relative "paycheck"

class Payday
  def initialize(pay_date)
    @pay_date = pay_date
    @paychecks = {}
  end

  def execute
    empIds = PayrollDatabase.get_all_employee_ids
    empIds.each do |empId|
      employee = PayrollDatabase.get_employee(empId)
      if (employee.pay_date?(@pay_date))
        pc = Paycheck.new(@pay_date)
        @paychecks[empId] = pc
        employee.payday(pc)
      end
    end
  end

  def get_paycheck(empId)
    @paychecks[empId]
  end
end
