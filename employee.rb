class Employee
  attr_reader :empid
  attr_accessor :classification, :schedule, :payment_method, :affiliation, :name, :address

  def initialize(empid, name, address)
    @empid = empid
    @name = name
    @address = address
  end
end
