require 'rubygems'

require 'rspec'
require 'webmock/rspec'

include WebMock::API

require 'webrick'
require File.dirname(__FILE__) + '/../lib/turbotlib'
