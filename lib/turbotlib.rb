require 'yaml'
require 'scraperwiki'

class Turbotlib
  class << self
    include ScraperWiki

    def log(message)
      $stderr.puts message
    end

    def data_dir
      path_to("data")
    end

    def sources_dir
      if in_production? && !is_admin?
        raise "Only admins are permitted to write to `sources_dir`"
      else
        path_to("sources")
      end
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

    def is_admin?
      ENV['USER_ROLES'].to_s.split(",").include?("admin")
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
        location = "/#{dir}"
      else
        location = dir
        set_up_dir(location)
      end
      location
    end

    def set_up_dir(location)
      begin
        Dir.mkdir(location)
      rescue Errno::EEXIST
      end
    end
  end
end
