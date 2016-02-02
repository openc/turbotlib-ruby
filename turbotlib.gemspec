require File.expand_path('../lib/turbotlib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name    = "turbotlib"
  gem.version = TurbotLib::VERSION

  gem.author      = "OpenCorporates"
  gem.email       = "bots@opencorporates.com"
  gem.homepage    = "https://github.com/openc/turbotlib-ruby"
  gem.summary     = "Helpers for writing Turbot bots"
  gem.license     = "MIT"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

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
