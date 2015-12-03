require 'pg_closure_tree_rebuild'
require 'benchmark'

namespace :closure_tree do
  desc 'Rebuild hierarchy (TABLE, HIERARCHIES, DATABASE_URL, PARENT_ID, ID)'
  task :rebuild do
    puts Benchmark.measure {
      db = Sequel.connect(ENV['DATABASE_URL'])

      PgClosureTreeRebuild::Runner.new(
        db, ENV['TABLE'], ENV['HIERARCHIES'], ENV['PARENT_ID'], ENV['ID']
      ).run
    }
  end
end
