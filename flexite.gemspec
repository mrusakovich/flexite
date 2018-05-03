$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "flexite/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "flexite"
  s.version     = Flexite::VERSION
  s.authors     = ["Maksim Rusakovich"]
  s.email       = ["rusakovich.maksim@gmail.com"]
  s.homepage    = "https://github.com/mrusakovich/flexite"
  s.summary     = "summary"
  s.description = "description"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.22"
  s.add_dependency "acts_as_tree", "~> 2.7.1"
end