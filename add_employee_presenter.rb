require_relative "add_hourly_employee"
require_relative "add_salaried_employee"
require_relative "add_commissioned_employee"

class AddEmployeePresenter
  attr_reader :empId, :name, :address, :hourly, :hourly_rate, :has_salary, :salary,
                :has_commission, :commission_salary, :commission
  def initialize(view, container, database)
    @view = view
    @container = container
    @database = database
  end

  def update_view
    @view.submit_enabled = all_information_is_collected
  end

  def all_information_is_collected
    result = true
    result &&= empId && empId > 0
    result &&= name && !name.empty?
    result &&= address && !address.empty?
    if hourly
      result &&= hourly_rate && hourly_rate > 0
    elsif has_salary
      result &&= salary && salary > 0
    elsif has_commission
      result &&= commission_salary && commission_salary > 0 && commission && commission > 0
    else
      result = false
    end

    result
  end

  def create_transaction
    if hourly
      AddHourlyEmployee.new(empId, name, address, hourly_rate, @database)
    elsif has_salary
      AddSalariedEmployee.new(empId, name, address, salary, @database)
    elsif has_commission
      AddCommissionedEmployee.new(empId, name, address, commission_salary, commission, @database)
    else
      nil
    end
  end

  def add_employee
    @container.transactions << create_transaction
  end

  def empId=(empId)
    @empId = empId
    update_view
    @empId
  end

  def name=(name)
    @name = name
    update_view
    @name
  end

  def address=(address)
    @address = address
    update_view
    @address
  end

  def hourly=(hourly)
    @hourly = hourly
    update_view
    @hourly
  end

  def hourly_rate=(hourly_rate)
    @hourly_rate = hourly_rate
    update_view
    @hourly_rate
  end

  def has_salary=(has_salary)
    @has_salary = has_salary
    update_view
    @has_salary
  end

  def salary=(salary)
    @salary = salary
    update_view
    @salary
  end

  def has_commission=(has_commission)
    @has_commission = has_commission
    update_view
    @has_commission
  end

  def commission_salary=(commission_salary)
    @commission_salary = commission_salary
    update_view
    @commission_salary
  end

  def commission=(commission)
    @commission = commission
    update_view
    @commission
  end
end
