# frozen_string_literal: true

require_relative 'no_affiliation'

# Models an employee
class Employee
  attr_reader :emp_id
  attr_accessor :classification, :schedule, :payment_method, :affiliation, :name, :address

  def initialize(emp_id, name, address)
    @emp_id = emp_id
    @name = name
    @address = address
    @affiliation = NoAffiliation.new
  end

  delegate :pay_date?, to: :schedule

  delegate :get_pay_period_start_date, to: :schedule

  def payday(pay_check)
    pay = classification.calculate_pay(pay_check)
    deductions = affiliation.calculate_deductions(pay_check)
    pay_check.gross_pay = pay
    pay_check.deductions = deductions
    pay_check.disposition = payment_method.disposition
    payment_method.pay(pay_check)
  end
end
