# frozen_string_literal: true

$payroll_environment = :test
require_relative 'payroll'
require 'minitest/spec'
require 'minitest/autorun'

DatabaseCleaner[:sequel].strategy = :truncation
DatabaseCleaner[:sequel].db = Sequel.connect(Relational::PostgresqlDatabase.connection_uri(Relational::PostgresqlDatabase.connection_options))

module DatabaseCleanerSupport
  def before_setup
    super
    DatabaseCleaner[:sequel].start
  end

  def after_teardown
    DatabaseCleaner[:sequel].clean
    super
  end
end
