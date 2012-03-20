require_relative "no_affiliation"

class Employee
  attr_reader :empid
  attr_accessor :classification, :schedule, :payment_method, :affiliation, :name, :address

  def initialize(empid, name, address)
    @empid = empid
    @name = name
    @address = address
    @affiliation = NoAffiliation.new
  end

  def pay_date?(date)
    schedule.pay_date?(date)
  end

  def payday(pc)
    pay = classification.calculate_pay(pc)
    deductions = affiliation.calculate_deductions
    pc.gross_pay = pay
    pc.deductions = deductions
    pc.disposition = payment_method.disposition
    payment_method.pay(pc)
  end
end
