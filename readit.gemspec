# -*- encoding: utf-8 -*-
require File.expand_path('../lib/readit/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["dongbin.li"]
  gem.email         = ["mike.d.1984@gmail.com"]
  gem.description   = %q{a simple readability api client}
  gem.summary       = %q{a simple readability api client}
  gem.homepage      = "https://github.com/29decibel/readit"

	gem.rubyforge_project = "readit"
	gem.add_dependency 'multi_json'
	gem.add_dependency 'hashie'
	gem.add_dependency 'oauth'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "readit"
  gem.require_paths = ["lib"]
  gem.version       = Readit::VERSION
end
