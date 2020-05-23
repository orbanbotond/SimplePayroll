# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

$payroll_environment ||= ENV["PAYROLL_ENVIRONMENT"  ] || :development

Bundler.require(  $payroll_environment, :default)

require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/try'

APP_ROOT = __dir__

class Payroll
  attr_reader :loader
  def initialize
    @loader = Zeitwerk::Loader.new
    loader.enable_reloading
    loader.push_dir File.join(APP_ROOT, 'concepts')
    loader.push_dir File.join(APP_ROOT, 'databases')
    loader.collapse("concepts/common")

    # A list of collapsing directories:
    # --
    # booking.rb                -> Booking
    # booking/actions/create.rb -> Booking::Create
    # loader.collapse("booking/actions")
    # loader.collapse("*/actions")

    # Inflection Rules:
    # --
    # loader.inflector.inflect(
    #   "html_parser"   => "HTMLParser",
    #   "mysql_adapter" => "MySQLAdapter"
    # )

    # Ignoring Files/Dirs:
    # --
    # loader.ignore(core_ext)
  end

  def init
    loader.setup
  end

  def reload
    loader.reload
  end
end

$payroll = Payroll.new
$payroll.init
