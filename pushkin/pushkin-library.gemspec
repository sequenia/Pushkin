$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pushkin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pushkin-library"
  s.version     = Pushkin::VERSION
  s.authors     = ["Bazov Peter"]
  s.email       = ["petr@sequenia.com"]
  s.homepage    = "http://sequenia.com/"
  s.summary     = "Push-Notifications Library"
  s.description = "Library for planning and sending Push-Notifications on iOS, Android and Web"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ['>= 5.0', '< 7']
  s.add_dependency "faraday", ['>= 0.12', '< 2']
end