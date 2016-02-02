# turbotlib-ruby

## Releasing a new version

Bump the version in `lib/turbotlib/version.rb` according to the [Semantic Versioning](http://semver.org/) convention, then:

    git commit lib/turbotlib/version.rb -m 'Release new version'
    rake release # requires Rubygems credentials
