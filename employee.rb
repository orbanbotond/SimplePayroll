class Employee
  attr_reader :name, :empid, :address
  attr_accessor :classification, :schedule, :payment_method

  def initialize(empid, name, address)
    @empid = empid
    @name = name
    @address = address
  end
end
