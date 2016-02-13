require 'rubygems'

require "simplecov"
require "coveralls"
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "spec"
end

require 'rspec'
require 'webmock/rspec'

include WebMock::API

require 'webrick'
require File.dirname(__FILE__) + '/../lib/turbotlib'
