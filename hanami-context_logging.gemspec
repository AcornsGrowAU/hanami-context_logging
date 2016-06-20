# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hanami/context_logging/version'

Gem::Specification.new do |spec|
  spec.name          = 'hanami-context_logging'
  spec.version       = Hanami::ContextLogging::VERSION
  spec.authors       = ['Kyle Chong']
  spec.email         = ['kyle.chong@acorns.com']

  spec.summary       = %q{Provides a Hanami logger formatter for logging with request auditing context.}
  spec.homepage      = 'https://github.com/Acornsgrow/hanami-context_logging'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'hanami-utils'
  spec.add_dependency 'rack-request_auditing', '~> 0.2'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
