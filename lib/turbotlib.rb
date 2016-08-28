require 'fileutils'
require 'forwardable'
require 'yaml'

require 'scraperwiki'

require 'turbotlib/logger'
require 'turbotlib/client'
require 'turbotlib/ftp'
require 'turbotlib/processor'
require 'turbotlib/base'

class Turbotlib
  include TurbotLib::Base
end
