require 'delegate'
require 'net/ftp'
require 'pathname'

require 'retriable'

class Turbotlib
  class FTPDelegator < SimpleDelegator
    # echanges.dila.gouv.fr sometimes returns a local IP (192.168.30.9) for the
    # host in `#makepasv`. We can store the first host received (which we assume
    # to be good), and return it every time. However, even with a good IP, the
    # next command times out. So, we instead retry the entire command with a new
    # client, after closing the old client.
    def method_missing(m, *args, &block)
      on_retry = Proc.new do |exception, try, elapsed_time, next_interval|
        @delegate_sd_obj.error("#{exception.message} on #{@delegate_sd_obj.last_cmd}")
        @delegate_sd_obj.close

        ftp = FTP.new(*@delegate_sd_obj.initialize_args)
        ftp.logger = @delegate_sd_obj.logger
        ftp.root_path = @delegate_sd_obj.root_path
        ftp.passive = true

        ftp.login
        dir = @delegate_sd_obj.last_dir.to_s
        unless dir.empty?
          ftp.chdir(dir)
        end

        __setobj__(ftp)
      end

      exception_classes = [Errno::ECONNRESET, Errno::ETIMEDOUT, EOFError]
      if Net.const_defined?(:ReadTimeout) # Ruby 2
        exception_classes << Net::ReadTimeout
      end

      Retriable.retriable(on: exception_classes, on_retry: on_retry) do
        super
      end
    end
  end

  class FTP < Net::FTP
    extend Forwardable

    attr_accessor :logger, :root_path
    attr_reader :initialize_args, :last_dir, :last_cmd

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    # Downloads a remote file.
    #
    # @param [String] remotefile the name of the remote file
    # @return [File] a local file with the remote file's contents
    def download(remotefile)
      info("get #{remotefile}")

      path = File.join(root_path, pwd, remotefile)

      if !Turbotlib.in_production? && File.exist?(path)
        File.open(path)
      else
        FileUtils.mkdir_p(File.dirname(path))
        File.open(path, 'w') do |f|
          getbinaryfile(remotefile, f.path)
        end
        File.open(path)
      end
    end

    def initialize(host = nil, user = nil, passwd = nil, acct = nil)
      # Store so we can recreate an FTP client.
      @initialize_args = [host, user, passwd, acct]
      @last_dir = Pathname.new('')
      @last_cmd = nil
      super
    end

    def login(*args)
      info('login')
      super
    end

    def nlst(dir = nil)
      if dir
        info("nlst #{dir}")
      else
        info('nlst')
      end
      super
    end

    def chdir(dirname)
      info("chdir #{dirname}")
      super
      # Store so we can resume from the directory.
      @last_dir += dirname
    end

  private

    def putline(line)
      # Store so we can report the command that errored.
      @last_cmd = line
      super
    end
  end
end
