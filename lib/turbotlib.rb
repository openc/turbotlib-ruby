require 'yaml'

require 'scraperwiki'

class Turbotlib
  class << self
    include ScraperWiki

    # Logs a message to STDERR.
    #
    # @param [String] message a log message
    def log(message)
      $stderr.puts message
    end

    # Returns the path to the data directory.
    #
    # @return [String] the path to the data directory
    def data_dir
      path_to('data')
    end

    # Returns the path to the sources directory.
    #
    # @return [String] the path to the sources directory
    def sources_dir
      if in_production? && !is_admin?
        raise 'Only admins are permitted to write to `sources_dir`'
      else
        path_to('sources')
      end
    end

    # Saves and returns the value of a variable.
    #
    # @param [String] a variable name
    # @param val the value of the variable
    # @return the value of the variable
    def save_var(key, val)
      vars = get_vars
      vars[key] = val
      save_vars(vars)
      val
    end

    # Returns the value of a variable.
    #
    # @param [String] a variable name
    # @return the value of the variable
    def get_var(key)
      get_vars[key]
    end

    # Override default in ScraperWiki gem.
    #
    # @return [SqliteMagic::Connection] a SQLite connection
    def sqlite_magic_connection
      db = "#{data_dir}/data.sqlite"
      @sqlite_magic_connection ||= SqliteMagic::Connection.new(db)
    end

    # Returns whether the environment is production.
    #
    # @return [Boolean] whether the environment is production
    def in_production?
      !!ENV['MORPH_URL']
    end

  private

    def is_admin?
      ENV['USER_ROLES'].to_s.split(',').include?('admin')
    end

    def get_vars
      begin
        YAML.load_file(vars_path)
      rescue Errno::ENOENT
        {}
      end
    end

    def save_vars(vars)
      yaml = YAML.dump(vars)
      File.write(vars_path, yaml)
    end

    def vars_path
      "#{data_dir}/_vars.yml"
    end

    def path_to(dir)
      if in_production?
        "/#{dir}"
      else
        begin
          Dir.mkdir(dir)
        rescue Errno::EEXIST
        end

        dir
      end
    end
  end
end
