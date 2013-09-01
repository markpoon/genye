require 'pry-rescue'
use PryRescue::Rack if ENV["RACK_ENV"] == 'development'
require "bundler/setup"
Bundler.require(:default)
require './app'
run Application
