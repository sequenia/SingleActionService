lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'single_action_service/version'

Gem::Specification.new do |spec|
  spec.name          = 'single_action_service'
  spec.version       = SingleActionService::VERSION
  spec.authors       = ['Bazov Peter']
  spec.email         = ['petr@sequenia.com']

  spec.summary       = 'Single Action Service'
  spec.description   = 'A Ruby library to organize the code'
  spec.homepage      = 'http://sequenia.com/'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem
  # that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
