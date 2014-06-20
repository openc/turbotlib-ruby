$:.unshift File.expand_path("../lib", __FILE__)
require "turbotlib/version"

Gem::Specification.new do |gem|
  gem.name    = "turbotlib"
  gem.version = TurbotLib::VERSION

  gem.author      = "Turbot"
  gem.email       = "support@turbot.opencorporates.com"
  gem.homepage    = "http://turbot.opencorporates.com/"
  gem.summary     = "Helpers for writing turbot bots."
  gem.description = ""
  gem.license     = "MIT"

  # use git to list files in main repo
  gem_files = %x{ git ls-files }.split("\n").select do |d|
    d =~ %r{^(License|README|lib/|spec/|test/)}
  end

  gem.required_ruby_version = '>=1.9.2'
  gem.add_dependency "openc_bot", "0.0.11"
end
