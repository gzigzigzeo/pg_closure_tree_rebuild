require 'ruby-progressbar'
require 'sequel'
require 'active_support/core_ext/string/inflections'

require 'pg_closure_tree_rebuild/version'
require 'pg_closure_tree_rebuild/builder'
require 'pg_closure_tree_rebuild/runner'
require 'pg_closure_tree_rebuild/railtie' if defined?(Rails)

module PgClosureTreeRebuild
  # Your code goes here...
end
