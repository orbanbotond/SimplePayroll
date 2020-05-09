# frozen_string_literal: true
#
# require_relative 'hourly/add_employee'
# require_relative 'salaried/add_employee'
# require_relative 'add_commissioned_employee'
#
# # Business Logic Which Adds an Employee Presenter
# class AddEmployeePresenter
#   attr_reader :emp_id, :name, :address, :hourly, :hourly_rate, :has_salary, :salary,
#               :has_commission, :commission_salary, :commission
#   def initialize(view, container, database)
#     @view = view
#     @container = container
#     @database = database
#   end
#
#   def update_view
#     @view.submit_enabled = all_information_is_collected
#   end
#
#   def all_information_is_collected
#     result = true
#     result &&= emp_id && emp_id > 0
#     result &&= name.present?
#     result &&= address.present?
#     if hourly
#       result &&= hourly_rate.present? && hourly_rate.positive?
#     elsif has_salary
#       result &&= salary.present? && salary.positive?
#     elsif has_commission
#       result &&= commission_salary.present? && commission_salary.positive? && commission.present? && commission.positive?
#     else
#       result = false
#     end
#
#     result
#   end
#
#   def create_transaction
#     if hourly
#       AddEmployee.new(emp_id, name, address, hourly_rate, @database)
#     elsif has_salary
#       AddEmployee.new(emp_id, name, address, salary, @database)
#     elsif has_commission
#       AddEmployee.new(emp_id, name, address, commission_salary, commission, @database)
#     end
#   end
#
#   def add_employee
#     @container.transactions << create_transaction
#   end
#
#   def emp_id=(emp_id)
#     @emp_id = emp_id
#     update_view
#     @emp_id
#   end
#
#   def name=(name)
#     @name = name
#     update_view
#     @name
#   end
#
#   def address=(address)
#     @address = address
#     update_view
#     @address
#   end
#
#   def hourly=(hourly)
#     @hourly = hourly
#     update_view
#     @hourly
#   end
#
#   def hourly_rate=(hourly_rate)
#     @hourly_rate = hourly_rate
#     update_view
#     @hourly_rate
#   end
#
#   def has_salary=(has_salary)
#     @has_salary = has_salary
#     update_view
#     @has_salary
#   end
#
#   def salary=(salary)
#     @salary = salary
#     update_view
#     @salary
#   end
#
#   def has_commission=(has_commission)
#     @has_commission = has_commission
#     update_view
#     @has_commission
#   end
#
#   def commission_salary=(commission_salary)
#     @commission_salary = commission_salary
#     update_view
#     @commission_salary
#   end
#
#   def commission=(commission)
#     @commission = commission
#     update_view
#     @commission
#   end
# end
