# frozen_string_literal: true
#
# require 'minitest/autorun'
# require_relative 'test_helper'
# require_relative '../add_employee_presenter'
# require_relative '../payroll_database'
#
# class MockAddEmployeeView
#   attr_accessor :submit_enabled
# end
#
# class TransactionContainer
#   attr_accessor :transactions
#
#   def initialize
#     @transactions = []
#   end
# end
# describe AddEmployeePresenter do
#   # before do
#   #   @view = MockAddEmployeeView.new
#   #   @container = TransactionContainer.new
#   #   @database = PayrollDatabase.instance
#   #   @presenter = AddEmployeePresenter.new(@view, @container, @database)
#   # end
#   #
#   # it 'should have all infos collected' do
#   #   assert_not(@presenter.all_information_is_collected)
#   #   @presenter.emp_id = 1
#   #   assert_not(@presenter.all_information_is_collected)
#   #   @presenter.name = 'Bill'
#   #   assert_not(@presenter.all_information_is_collected)
#   #   @presenter.address = '123 abc'
#   #   assert_not(@presenter.all_information_is_collected)
#   #   @presenter.hourly = true
#   #   assert_not(@presenter.all_information_is_collected)
#   #   @presenter.hourly_rate = 1.23
#   #   assert(@presenter.all_information_is_collected)
#   #
#   #   @presenter.hourly = false
#   #   assert_not(@presenter.all_information_is_collected)
#   #   @presenter.has_salary = true
#   #   assert_not(@presenter.all_information_is_collected)
#   #   @presenter.salary = 1234
#   #   assert(@presenter.all_information_is_collected)
#   #
#   #   @presenter.has_salary = false
#   #   assert_not(@presenter.all_information_is_collected)
#   #   @presenter.has_commission = true
#   #   assert_not(@presenter.all_information_is_collected)
#   #   @presenter.commission_salary = 1234
#   #   assert_not(@presenter.all_information_is_collected)
#   #   @presenter.commission = 12
#   #   assert(@presenter.all_information_is_collected)
#   # end
#   #
#   # it 'should update view' do
#   #   @presenter.emp_id = 1
#   #   check_submit_enabled(false)
#   #
#   #   @presenter.name = 'Bill'
#   #   check_submit_enabled(false)
#   #
#   #   @presenter.address = '123 abc'
#   #   check_submit_enabled(false)
#   #
#   #   @presenter.hourly = true
#   #   check_submit_enabled(false)
#   #
#   #   @presenter.hourly_rate = 1.23
#   #   check_submit_enabled(true)
#   # end
#   #
#   # def check_submit_enabled(expected)
#   #   if expected
#   #     assert(@view.submit_enabled)
#   #   else
#   #     assert_not(@view.submit_enabled)
#   #   end
#   # end
#   #
#   # it 'should create transaction' do
#   #   @presenter.emp_id = 123
#   #   @presenter.name = 'Joe'
#   #   @presenter.address = '314 Elm'
#   #
#   #   @presenter.hourly = true
#   #   @presenter.hourly_rate = 10
#   #   @presenter.create_transaction.must_be_kind_of AddEmployee
#   #
#   #   @presenter.hourly = false
#   #   @presenter.has_salary = true
#   #   @presenter.salary = 3000
#   #   @presenter.create_transaction.must_be_kind_of AddEmployee
#   #
#   #   @presenter.has_salary = false
#   #   @presenter.has_commission = true
#   #   @presenter.commission_salary = 1000
#   #   @presenter.commission = 25
#   #   @presenter.create_transaction.must_be_kind_of AddCommissionedEmployee
#   # end
#   #
#   # it 'should add an employee' do
#   #   @presenter.emp_id = 123
#   #   @presenter.name = 'Joe'
#   #   @presenter.address = '314 Elm'
#   #   @presenter.hourly = true
#   #   @presenter.hourly_rate = 25
#   #
#   #   @presenter.add_employee
#   #
#   #   @container.transactions.count.must_equal 1
#   #   @container.transactions.first.must_be_kind_of AddEmployee
#   # end
# end
