$:.push File.expand_path("lib", __dir__)

require "auto_previews/version"

Gem::Specification.new do |spec|
  spec.name        = "auto_previews"
  spec.version     = AutoPreviews::VERSION
  spec.authors     = ["Josh Brody"]
  spec.email       = ["git@josh.mn"]
  spec.homepage    = "https://github.com/joshmn/auto_previews"
  spec.summary     = "Automatically create mailer previews for your mailers."
  spec.description = spec.summary
  spec.license     = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.3", ">= 5.1"

  spec.add_development_dependency "sqlite3"
end
