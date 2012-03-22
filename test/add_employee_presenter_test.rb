require "minitest/autorun"
require_relative "../add_employee_presenter"
require_relative "../payroll_database"

class MockAddEmployeeView
  def submit_enabled
    @enabled || false
  end

  def submit_enabled=(enabled)
    @count ||= 0
    @count += 1
    @enabled = enabled
  end

  def submit_enabled_count
    @count
  end
end

class TransactionContainer
  attr_accessor :transactions

  def initialize
    @transactions = []
  end
end

describe AddEmployeePresenter do

  before do
    @view = MockAddEmployeeView.new
    @container = TransactionContainer.new
    @database = PayrollDatabase.instance
    @presenter = AddEmployeePresenter.new(@view, @container, @database)
  end

  it "should have all infos collected" do
    assert(!@presenter.all_information_is_collected)
    @presenter.empId = 1
    assert(!@presenter.all_information_is_collected)
    @presenter.name = "Bill"
    assert(!@presenter.all_information_is_collected)
    @presenter.address = "123 abc"
    assert(!@presenter.all_information_is_collected)
    @presenter.hourly = true
    assert(!@presenter.all_information_is_collected)
    @presenter.hourly_rate = 1.23
    assert(@presenter.all_information_is_collected)

    @presenter.hourly = false
    assert(!@presenter.all_information_is_collected)
    @presenter.has_salary = true
    assert(!@presenter.all_information_is_collected)
    @presenter.salary = 1234
    assert(@presenter.all_information_is_collected)

    @presenter.has_salary = false
    assert(!@presenter.all_information_is_collected)
    @presenter.has_commission = true
    assert(!@presenter.all_information_is_collected)
    @presenter.commission_salary = 1234
    assert(!@presenter.all_information_is_collected)
    @presenter.commission = 12
    assert(@presenter.all_information_is_collected)
  end

  it "should update view" do
    @presenter.empId = 1
    check_submit_enabled(false, 1)

    @presenter.name = "Bill"
    check_submit_enabled(false, 2)

    @presenter.address = "123 abc"
    check_submit_enabled(false, 3)

    @presenter.hourly = true
    check_submit_enabled(false, 4)

    @presenter.hourly_rate = 1.23
    check_submit_enabled(true, 5)
  end

  def check_submit_enabled(expected, count)
    @view.submit_enabled.must_equal expected
    @view.submit_enabled_count.must_equal count
  end

  it "should create transaction" do
    @presenter.empId = 123
    @presenter.name = "Joe"
    @presenter.address = "314 Elm"

    @presenter.hourly = true
    @presenter.hourly_rate = 10
    @presenter.create_transaction.must_be_kind_of AddHourlyEmployee

    @presenter.hourly = false
    @presenter.has_salary = true
    @presenter.salary = 3000
    @presenter.create_transaction.must_be_kind_of AddSalariedEmployee

    @presenter.has_salary = false
    @presenter.has_commission = true
    @presenter.commission_salary = 1000
    @presenter.commission = 25
    @presenter.create_transaction.must_be_kind_of AddCommissionedEmployee
  end

  it "should add an employee" do
    @presenter.empId = 123
    @presenter.name = "Joe"
    @presenter.address = "314 Elm"
    @presenter.hourly = true
    @presenter.hourly_rate = 25

    @presenter.add_employee

    @container.transactions.count.must_equal 1
    @container.transactions.first.must_be_kind_of AddHourlyEmployee
  end
end
