$:.unshift File.expand_path("../lib", __FILE__)
require "vagrant-fifo/version"

Gem::Specification.new do |s|
  s.name          = "vagrant-fifo"
  s.version       = VagrantPlugins::Fifo::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = [ "Sean OMeara", "Brian Akins" ]
  s.email         = [ "someara@opscode.com", "brian@akins.org" ]
  s.homepage      = "http://www.vagrantup.com"
  s.summary       = "Enables Vagrant to manage machines in Fifo cloud and SDC"
  s.description   = "Enables Vagrant to manage machines in Fifo cloud and SDC"

  s.add_dependency "project-fifo-ruby"

  s.files         = `git ls-files`.split($/)
  s.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_path  = 'lib'
end
