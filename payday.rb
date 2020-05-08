# frozen_string_literal: true

require_relative 'paycheck'

# Business Logic encapsulating the PayRoll on a given paydate
class Payday
  def initialize(pay_date, database)
    @pay_date = pay_date
    @database = database
    @paychecks = {}
  end

  def execute
    emp_ids = @database.all_employee_ids
    emp_ids.each do |emp_id|
      employee = @database.get_employee(emp_id)
      next unless employee.pay_date?(@pay_date)

      start_date = employee.get_pay_period_start_date(@pay_date)
      pay_check = Paycheck.new(start_date, @pay_date)
      @paychecks[emp_id] = pay_check
      employee.payday(pay_check)
    end
  end

  def get_paycheck(emp_id)
    @paychecks[emp_id]
  end
end
