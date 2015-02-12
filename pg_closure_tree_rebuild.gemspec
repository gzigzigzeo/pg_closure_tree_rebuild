# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pg_closure_tree_rebuild/version'

Gem::Specification.new do |spec|
  spec.name          = 'pg_closure_tree_rebuild'
  spec.version       = PgClosureTreeRebuild::VERSION
  spec.authors       = ['Viktor Sokolov']
  spec.email         = ['gzigzigzeo@evilmartians.com']

  spec.summary       = %q{Quick #rebuild! method implementation for closure_tree on PostgreSQL.}
  spec.description   = %q{Quick #rebuild! method implementation for closure_tree on PostgreSQL.}
  spec.homepage      = "http://github.com/gzigzigzeo/pg_closure_tree_rebuild"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'sequel'
  spec.add_dependency 'pg'
  spec.add_dependency 'ruby-progressbar'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'sqlite3'
end
