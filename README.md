# turbotlib-ruby

[![Gem Version](https://badge.fury.io/rb/turbotlib.svg)](https://badge.fury.io/rb/turbotlib)
[![Build Status](https://secure.travis-ci.org/openc/turbotlib-ruby.png)](https://travis-ci.org/openc/turbotlib-ruby)
[![Dependency Status](https://gemnasium.com/openc/turbotlib-ruby.png)](https://gemnasium.com/openc/turbotlib-ruby)
[![Coverage Status](https://coveralls.io/repos/openc/turbotlib-ruby/badge.png)](https://coveralls.io/r/openc/turbotlib-ruby)
[![Code Climate](https://codeclimate.com/github/openc/turbotlib-ruby.png)](https://codeclimate.com/github/openc/turbotlib-ruby)

## Releasing a new version

Bump the version in `lib/turbotlib/version.rb` according to the [Semantic Versioning](http://semver.org/) convention, then:

    git commit lib/turbotlib/version.rb -m 'Release new version'
    rake release # requires Rubygems credentials

Finally, [rebuild the Docker image](https://github.com/openc/morph-docker-ruby#readme).
