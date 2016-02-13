require 'spec_helper'

describe Turbotlib::Logger do
  let :logdev do
    StringIO.new
  end

  let :logger do
    Turbotlib::Logger.new('foo', 'INFO', logdev)
  end

  describe '#info' do
    it 'logs formatted messages' do
      logger.info('bar')
      expect(logdev.string).to match(/\A\d\d:\d\d:\d\d INFO foo: bar\n\z/)
    end
  end
end
