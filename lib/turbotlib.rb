module Turbotlib
  def self.log(message)
    $stderr.puts message
  end

  def self.data_dir
    if in_production?
      "/data/"
    else
      "data/"
    end
  end

  private
  def self.in_production?
    !!ENV['MORPH_URL']
  end

end
