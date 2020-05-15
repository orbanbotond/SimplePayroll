# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)

require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank.rb'

APP_ROOT = __dir__
$LOAD_PATH << File.join(APP_ROOT, 'classifications')
$LOAD_PATH << File.join(APP_ROOT, 'common')
$LOAD_PATH << File.join(APP_ROOT, 'schedules')
$LOAD_PATH << File.join(APP_ROOT, 'union')
$LOAD_PATH << File.join(APP_ROOT, 'databases')
