require 'spec_helper'

describe Turbotlib::Processor do
  after do
    if Dir.exist?('output')
      Dir.rmdir('output')
    end
  end

  let :logdev do
    StringIO.new
  end

  let :processor do
    Turbotlib::Processor.new('output', '_cache', 60, 'INFO', logdev)
  end

  describe '#initialize' do
    it 'creates an output directory' do
      processor
      expect(Dir.exist?('output')).to eq(true)
    end

    it 'uses sensible defaults' do
      processor = Turbotlib::Processor.new
      expect(processor.instance_variable_get(:@output_dir)).to eq(Turbotlib.data_dir)
      logger = processor.instance_variable_get(:@logger)
      expect(logger.level).to eq(Logger::WARN)
      # would like to test more methods, but buried inside Faraday instances within instances
    end
  end

  describe '#get' do
    it 'returns the body of an HTTP response' do
      stub_request(:get, 'http://example.com/').to_return(:status => 200, :body => 'test')

      expect(processor.get('http://example.com/')).to eq('test')
    end
  end

  describe '#assert' do
    it 'logs no message if the block returns true' do
      processor.assert('passes'){true}
      expect(logdev.string).to eq('')
    end

    it 'logs a message if the block returns false' do
      processor.assert('fails'){false}
      expect(logdev.string).to match(/\A\d\d:\d\d:\d\d ERROR turbot: fails\n\z/)
    end
  end

  describe '#now' do
    it 'returns the current time in ISO 8601' do
      expect(processor.now).to match(/\A\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\dZ\z/)
    end
  end
end
