require 'yaml'
require 'scraperwiki'

class Turbotlib
  class << self
    include ScraperWiki

    def log(message)
      $stderr.puts message
    end

    def data_dir
      set_up_data_dir
      data_dir_location
    end

    def save_var(key, val)
      vars = get_vars
      vars[key] = val
      save_vars(vars)
      val
    end

    def get_var(key)
      get_vars[key]
    end

    # Override default in ScraperWiki gem
    def sqlite_magic_connection
      db = "#{data_dir}/data.sqlite"
      @sqlite_magic_connection ||= SqliteMagic::Connection.new(db)
    end

    private
    def in_production?
      !!ENV['MORPH_URL']
    end

    def get_vars
      begin
        YAML.load_file(vars_path)
      rescue Errno::ENOENT
        {}
      end
    end

    def save_vars(vars)
      yaml = YAML.dump(vars, f)
      File.write(vars_path, yaml)
    end

    def vars_path
      "#{data_dir}/_vars.yml"
    end

    def data_dir_location
      if in_production?
        "/data"
      else
        "data"
      end
    end

    def set_up_data_dir
      begin
        Dir.mkdir(data_dir_location)
      rescue Errno::EEXIST
      end
    end
  end
end
