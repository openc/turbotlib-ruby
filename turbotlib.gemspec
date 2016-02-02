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
  gem.files = %x{ git ls-files }.split("\n").select do |d|
    d =~ %r{^(License|README|lib/|spec/|test/)}
  end

  gem.required_ruby_version = '>=1.9.2'
  gem.add_dependency "scraperwiki", "3.0.2"
  gem.add_development_dependency "coveralls"
  gem.add_development_dependency "debugger"
  gem.add_development_dependency "excon"
  gem.add_development_dependency "json"
  gem.add_development_dependency "rake", ">= 0.8.7"
  gem.add_development_dependency "rr", "~> 1.0.2"
  gem.add_development_dependency "rspec", ">= 2.0"
end
