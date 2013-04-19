require File.expand_path("../lib/capssh/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "capssh"
  s.version     = Capssh::VERSION
  s.license     = "MIT"
  s.summary     = "Easily connect via SSH to different environments configured for this project."
  s.description = "A utility that allows you to easily SSH into a server defined in a capistrano configuration file."
  s.authors     = ["John Wood"]
  s.email       = ["john@johnpwood.net"]
  s.files       = ["lib/capssh.rb", "lib/capssh/version.rb"]
  s.executables = ["capssh"]
  s.homepage    = "https://github.com/centro/capssh"

  s.add_development_dependency "rspec"
end
