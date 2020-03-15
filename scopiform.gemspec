$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "scopiform/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "scopiform"
  spec.version     = Scopiform::VERSION
  spec.authors     = ["jayce.pulsipher"]
  spec.email       = ["jayce.pulsipher@3-form.com"]
  spec.homepage    = "https://github.com/3-form/scopiform"
  spec.summary     = "Generate scope methods to ActiveRecord classes based on columns and associations"
  # spec.description = ""
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 4.2.7"

  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "sqlite3"
end
