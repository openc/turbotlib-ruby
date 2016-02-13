require 'faraday'

begin
  require 'faraday_middleware'
  require 'active_support/cache'
rescue LoadError
  # Production doesn't need caching.
end

class Turbotlib
  class Client
    def self.new(cache_dir, expires_in, level, logdev)
      Faraday.new do |connection|
        connection.request :url_encoded
        connection.request :retry
        connection.use Faraday::Response::Logger, Logger.new('faraday', level, logdev)
        if defined?(FaradayMiddleware) && cache_dir
          connection.response :caching do
            ActiveSupport::Cache::FileStore.new(cache_dir, expires_in: expires_in)
          end
        end
        connection.adapter Faraday.default_adapter
      end
    end
  end
end
