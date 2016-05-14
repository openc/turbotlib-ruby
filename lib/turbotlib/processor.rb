class Turbotlib
  class Processor
    extend Forwardable

    attr_reader :client

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def initialize(output_dir= Turbotlib.data_dir, cache_dir=nil, expires_in=0, level='WARN', logdev=STDERR)
      @logger = Logger.new('turbot', level, logdev)
      @client = Client.new(cache_dir, expires_in, level, logdev)

      @output_dir = output_dir
      FileUtils.mkdir_p(@output_dir) unless Dir.exist?(@output_dir)
    end

    def get(url)
      client.get(url).body
    end

    def assert(message)
      error(message) unless yield
    end

    # @return [String] the present UTC time in ISO 8601 format
    def now
      Time.now.utc.strftime('%Y-%m-%dT%H:%M:%SZ')
    end
  end
end
